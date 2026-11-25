# Windows Maintenance Toolkit
# Script: 07-Software-Removal.ps1
# Purpose: Controlled software removal and leftover inspection
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\Software-Removal_$Timestamp.log"

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

try {
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw "WinGet is not installed or available."
    }

    do {
        Write-Host "`n===== SOFTWARE REMOVAL =====" -ForegroundColor Cyan
        Write-Host "1. List installed applications"
        Write-Host "2. Search installed applications"
        Write-Host "3. Uninstall a specific application"
        Write-Host "4. Inspect potential leftover directories"
        Write-Host "5. Open Windows Installed Apps"
        Write-Host "6. Exit"

        $Choice = Read-Host "Select an option"

        try {
            switch ($Choice) {
                "1" {
                    winget list
                    Write-Host "Exit code: $LASTEXITCODE"
                }

                "2" {
                    $Search = Read-Host "Enter application name"

                    if (-not [string]::IsNullOrWhiteSpace($Search)) {
                        winget list --query "$Search"
                        Write-Host "Exit code: $LASTEXITCODE"
                    }
                }

                "3" {
                    $AppID = Read-Host "Enter exact application ID"

                    if (-not [string]::IsNullOrWhiteSpace($AppID)) {
                        winget list --id "$AppID" --exact

                        if ($LASTEXITCODE -eq 0) {
                            $Confirm = Read-Host "Uninstall $AppID? (Y/N)"

                            if ($Confirm -eq "Y") {
                                winget uninstall --id "$AppID" --exact
                                $Code = $LASTEXITCODE

                                Write-Host "Exit code: $Code"

                                if ($Code -ne 0) {
                                    Write-Warning "Review uninstallation results."
                                }
                            }
                        }
                        else {
                            Write-Warning "Application could not be identified."
                        }
                    }
                }

                "4" {
                    $Search = Read-Host "Enter application or publisher name"

                    if (-not [string]::IsNullOrWhiteSpace($Search)) {
                        $Locations = @(
                            $env:ProgramFiles
                            ${env:ProgramFiles(x86)}
                            $env:ProgramData
                            $env:APPDATA
                            $env:LOCALAPPDATA
                        ) | Where-Object { $_ } | Select-Object -Unique

                        $Results = @(
                            foreach ($Location in $Locations) {
                                if (Test-Path -LiteralPath $Location) {
                                    Get-ChildItem -LiteralPath $Location `
                                        -Directory -Force `
                                        -ErrorAction SilentlyContinue |
                                    Where-Object {
                                        $_.Name.IndexOf(
                                            $Search,
                                            [StringComparison]::OrdinalIgnoreCase
                                        ) -ge 0
                                    } |
                                    Select-Object FullName, LastWriteTime
                                }
                            }
                        )

                        if ($Results.Count -gt 0) {
                            $Results | Format-List

                            $Report = "$Root\Reports\Software-Leftovers_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').csv"

                            $Results | Export-Csv $Report `
                                -NoTypeInformation -Encoding UTF8

                            Write-Host "Report: $Report"
                        }
                        else {
                            Write-Host "No matching directories found."
                        }

                        Write-Host "Inspection only. No files deleted." -ForegroundColor Yellow
                    }
                }

                "5" {
                    Start-Process "ms-settings:appsfeatures"
                }

                "6" {
                    Write-Host "Exiting software removal."
                }

                default {
                    Write-Host "Invalid selection." -ForegroundColor Yellow
                }
            }
        }
        catch {
            Write-Host "Operation failed: $_" -ForegroundColor Red
        }

    } while ($Choice -ne "6")
}
finally {
    Write-Host "Log: $Log"
    Stop-Transcript | Out-Null
}
