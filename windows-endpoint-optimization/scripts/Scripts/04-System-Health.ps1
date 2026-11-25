# Windows Maintenance Toolkit
# Script: 04-System-Health.ps1
# Purpose: Windows integrity diagnostics and repair
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\System-Health_$Timestamp.log"

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

function Invoke-HealthCommand {
    param(
        [string]$Program,
        [string[]]$Arguments
    )

    Write-Host "`nRunning: $Program $Arguments" -ForegroundColor Cyan

    & $Program @Arguments | Out-Host

    $ExitCode = $LASTEXITCODE

    Write-Host "Exit code: $ExitCode"

    if ($ExitCode -ne 0) {
        Write-Warning "Review the command results before continuing."
    }

    return ($ExitCode -eq 0)
}

try {
    do {
        Write-Host "`n===== SYSTEM HEALTH =====" -ForegroundColor Cyan
        Write-Host "1. DISM - Quick health check"
        Write-Host "2. DISM - Detailed health scan"
        Write-Host "3. DISM - Repair component store"
        Write-Host "4. SFC  - Verify system files"
        Write-Host "5. SFC  - Scan and repair system files"
        Write-Host "6. Full system repair"
        Write-Host "7. Exit"

        $Choice = Read-Host "Select an option"

        switch ($Choice) {
            "1" {
                Invoke-HealthCommand dism.exe @(
                    "/Online", "/Cleanup-Image", "/CheckHealth"
                ) | Out-Null
            }

            "2" {
                Invoke-HealthCommand dism.exe @(
                    "/Online", "/Cleanup-Image", "/ScanHealth"
                ) | Out-Null
            }

            "3" {
                if ((Read-Host "Repair Windows component store? (Y/N)") -eq "Y") {
                    Invoke-HealthCommand dism.exe @(
                        "/Online", "/Cleanup-Image", "/RestoreHealth"
                    ) | Out-Null
                }
            }

            "4" {
                Invoke-HealthCommand sfc.exe @(
                    "/verifyonly"
                ) | Out-Null
            }

            "5" {
                if ((Read-Host "Scan and repair system files? (Y/N)") -eq "Y") {
                    Invoke-HealthCommand sfc.exe @(
                        "/scannow"
                    ) | Out-Null
                }
            }

            "6" {
                if ((Read-Host "Perform full Windows system repair? (Y/N)") -eq "Y") {
                    $Result = Invoke-HealthCommand dism.exe @(
                        "/Online", "/Cleanup-Image", "/RestoreHealth"
                    )

                    if ($Result) {
                        Invoke-HealthCommand sfc.exe @(
                            "/scannow"
                        ) | Out-Null
                    }
                    else {
                        Write-Warning "DISM did not complete successfully. SFC skipped."
                    }
                }
            }

            "7" {
                Write-Host "Exiting system health."
            }

            default {
                Write-Host "Invalid selection." -ForegroundColor Yellow
            }
        }

    } while ($Choice -ne "7")
}
catch {
    Write-Host "System health error: $_" -ForegroundColor Red
    throw
}
finally {
    Write-Host "Log: $Log"
    Stop-Transcript | Out-Null
}
