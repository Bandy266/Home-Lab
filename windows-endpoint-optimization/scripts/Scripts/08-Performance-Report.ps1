# Windows Maintenance Toolkit
# Script: 08-Performance-Report.ps1
# Purpose: Compare current performance against original baseline
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\Performance-Report_$Timestamp.log"
$Report = "$Root\Reports\Performance-Report_$Timestamp.txt"
$History = "$Root\Reports\Performance-History.csv"
$BaselinePath = "$Root\Reports\Original-Baseline.json"

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

try {
    if (-not (Test-Path -LiteralPath $BaselinePath)) {
        throw "Original baseline file not found."
    }

    $Baseline = Get-Content $BaselinePath -Raw |
        ConvertFrom-Json

    $OS = Get-CimInstance Win32_OperatingSystem
    $Computer = Get-CimInstance Win32_ComputerSystem

    $Current = [PSCustomObject]@{
        Timestamp       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Build           = $OS.BuildNumber
        Processes       = (Get-Process).Count
        RunningServices = @(Get-Service |
            Where-Object Status -eq "Running").Count
        TotalRAM_GB     = [math]::Round(
            $OS.TotalVisibleMemorySize / 1MB, 2
        )
        UsedRAM_GB      = [math]::Round(
            ($OS.TotalVisibleMemorySize -
            $OS.FreePhysicalMemory) / 1MB, 2
        )
        RAMUsage_Pct    = [math]::Round(
            (1 - $OS.FreePhysicalMemory /
            $OS.TotalVisibleMemorySize) * 100, 2
        )
        Hypervisor      = $Computer.HypervisorPresent
    }

    $Metrics = @(
        "Processes"
        "RunningServices"
        "UsedRAM_GB"
        "RAMUsage_Pct"
    )

    $Comparison = foreach ($Metric in $Metrics) {
        $Original = [double]$Baseline.$Metric
        $Now = [double]$Current.$Metric

        $Reduction = if ($Original -ne 0) {
            [math]::Round(
                (($Original - $Now) / $Original) * 100, 2
            )
        }
        else {
            $null
        }

        [PSCustomObject]@{
            Metric        = $Metric
            Baseline      = $Original
            Current       = $Now
            Change        = [math]::Round($Now - $Original, 2)
            Reduction_Pct = $Reduction
        }
    }

    Write-Host "`n===== PERFORMANCE COMPARISON =====" -ForegroundColor Cyan

    $Comparison | Format-Table -AutoSize

    Write-Host "Original hypervisor status: $($Baseline.Hypervisor)"
    Write-Host "Current hypervisor status:  $($Current.Hypervisor)"

    if ($Current.Hypervisor -ne $Baseline.Hypervisor) {
        Write-Warning "Hypervisor status has changed."
    }

    "===== PERFORMANCE COMPARISON =====" |
        Out-File $Report

    $Comparison |
        Format-Table -AutoSize |
        Out-String -Width 200 |
        Out-File $Report -Append

    "`n===== CURRENT SYSTEM STATUS =====" |
        Out-File $Report -Append

    $Current |
        Format-List |
        Out-String |
        Out-File $Report -Append

    $Current | Export-Csv $History `
        -Append -NoTypeInformation -Encoding UTF8

    Write-Host "`nPositive reduction = lower resource usage."
    Write-Host "Negative reduction = higher resource usage."

    Write-Host "`nPerformance report completed." -ForegroundColor Green
    Write-Host "Report:  $Report"
    Write-Host "History: $History"
    Write-Host "Log:     $Log"
}
catch {
    Write-Host "Performance report failed: $_" -ForegroundColor Red
    throw
}
finally {
    Stop-Transcript | Out-Null
}
