# Windows Maintenance Toolkit
# Script: 03-Software-Updates.ps1
# Purpose: Manage application updates using WinGet
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\Software-Updates_$Timestamp.log"

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
        Write-Host "`n===== SOFTWARE UPDATES =====" -ForegroundColor Cyan
        Write-Host "1. Check available updates"
        Write-Host "2. Update a specific application"
        Write-Host "3. Update all eligible applications"
        Write-Host "4. Exit"

        $Choice = Read-Host "Select an option"

        switch ($Choice) {
            "1" {
                winget upgrade
                Write-Host "WinGet exit code: $LASTEXITCODE"
            }

            "2" {
                winget upgrade
                $AppID = Read-Host "Enter the application ID"

                if (-not [string]::IsNullOrWhiteSpace($AppID)) {
                    $Confirm = Read-Host "Update $AppID? (Y/N)"

                    if ($Confirm -eq "Y") {
                        winget upgrade --id "$AppID" --exact
                        Write-Host "WinGet exit code: $LASTEXITCODE"
                    }
                }
            }

            "3" {
                winget upgrade
                $Confirm = Read-Host "Install all eligible updates? (Y/N)"

                if ($Confirm -eq "Y") {
                    winget upgrade --all
                    Write-Host "WinGet exit code: $LASTEXITCODE"
                }
                else {
                    Write-Host "Updates cancelled."
                }
            }

            "4" {
                Write-Host "Exiting software updates."
            }

            default {
                Write-Host "Invalid selection." -ForegroundColor Yellow
            }
        }
    } while ($Choice -ne "4")
}
catch {
    Write-Host "Software update error: $_" -ForegroundColor Red
    throw
}
finally {
    Write-Host "Log: $Log"
    Stop-Transcript | Out-Null
}
