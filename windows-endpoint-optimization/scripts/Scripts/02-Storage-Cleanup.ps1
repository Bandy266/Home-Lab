# Windows Maintenance Toolkit
# Script: 02-Storage-Cleanup.ps1
# Purpose: Safe temporary file cleanup
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\Storage-Cleanup_$Timestamp.log"
$Report = "$Root\Reports\Storage-Cleanup_$Timestamp.txt"
$Cutoff = (Get-Date).AddDays(-7)

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

try {
    $Locations = @(
        "$env:LOCALAPPDATA\Temp"
        "$env:windir\Temp"
    ) | Select-Object -Unique

    $Before = (Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'").FreeSpace

    $Files = @(
        foreach ($Location in $Locations) {
            if (Test-Path -LiteralPath $Location) {
                Get-ChildItem -LiteralPath $Location -File -Recurse -Force -ErrorAction SilentlyContinue |
                    Where-Object {
                        $_.LastWriteTime -lt $Cutoff -and
                        $_.FullName -notmatch '\\(OneDrive|Downloads)\\' -and
                        -not ($_.Attributes -band [IO.FileAttributes]::ReparsePoint)
                    }
            }
        }
    )

    $PotentialBytes = ($Files | Measure-Object Length -Sum).Sum

    Write-Host "`n===== STORAGE CLEANUP =====" -ForegroundColor Cyan
    Write-Host "Eligible files: $($Files.Count)"
    Write-Host "Potential cleanup: $([math]::Round($PotentialBytes / 1MB, 2)) MB"

    $Deleted = 0
    $Skipped = 0
    $DeletedBytes = 0
    $Choice = Read-Host "Delete eligible temporary files? (Y/N)"

    if ($Choice -eq "Y") {
        foreach ($File in $Files) {
            try {
                Remove-Item -LiteralPath $File.FullName -Force -ErrorAction Stop
                $Deleted++
                $DeletedBytes += $File.Length
            }
            catch {
                $Skipped++
                Write-Host "Skipped: $($File.FullName)"
            }
        }
    }
    else {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    }

    $After = (Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'").FreeSpace

    $Summary = [PSCustomObject]@{
        Timestamp           = Get-Date
        EligibleFiles       = $Files.Count
        DeletedFiles        = $Deleted
        SkippedFiles        = $Skipped
        PotentialCleanup_MB = [math]::Round($PotentialBytes / 1MB, 2)
        DeletedFileSize_MB  = [math]::Round($DeletedBytes / 1MB, 2)
        FreeSpaceBefore_GB  = [math]::Round($Before / 1GB, 2)
        FreeSpaceAfter_GB   = [math]::Round($After / 1GB, 2)
        FreeSpaceChange_MB  = [math]::Round(($After - $Before) / 1MB, 2)
    }

    $Summary | Format-List
    $Summary | Format-List | Out-String | Out-File $Report

    $DiskCleanup = Read-Host "Open Windows Disk Cleanup? (Y/N)"

    if ($DiskCleanup -eq "Y") {
        Start-Process cleanmgr.exe -Wait
    }

    Write-Host "Storage cleanup session completed." -ForegroundColor Green
    Write-Host "Report: $Report"
    Write-Host "Log:    $Log"
}
catch {
    Write-Host "Cleanup failed: $_" -ForegroundColor Red
    throw
}
finally {
    Stop-Transcript | Out-Null
}
