# Windows Maintenance Toolkit
# Script: Maintenance.ps1
# Purpose: Central maintenance interface
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$Scripts = Join-Path $Root "Scripts"

$Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($Identity)

if (-not $Principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    Write-Warning "Please run this toolkit as Administrator."
    return
}

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

$Menu = [ordered]@{
    "1" = "01-System-Audit.ps1"
    "2" = "02-Storage-Cleanup.ps1"
    "3" = "03-Software-Updates.ps1"
    "4" = "04-System-Health.ps1"
    "5" = "05-Security-Check.ps1"
    "6" = "06-Startup-Audit.ps1"
    "7" = "07-Software-Removal.ps1"
    "8" = "08-Performance-Report.ps1"
}

do {
    Clear-Host

    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "     WINDOWS MAINTENANCE TOOLKIT" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Version 1.0 | Administrator Mode"
    Write-Host ""
    Write-Host " 1. System Audit"
    Write-Host " 2. Storage Cleanup"
    Write-Host " 3. Software Updates"
    Write-Host " 4. System Health"
    Write-Host " 5. Security Check"
    Write-Host " 6. Startup Audit"
    Write-Host " 7. Software Removal"
    Write-Host " 8. Performance Report"
    Write-Host ""
    Write-Host " 9. Open Reports Folder"
    Write-Host "10. Open Logs Folder"
    Write-Host "11. Open Backups Folder"
    Write-Host ""
    Write-Host " 0. Exit"
    Write-Host "========================================" -ForegroundColor Cyan

    $Choice = Read-Host "Select an option"

    try {
        if ($Menu.Contains($Choice)) {
            $ScriptPath = Join-Path $Scripts $Menu[$Choice]

            if (Test-Path -LiteralPath $ScriptPath) {
                Write-Host "`nLaunching $($Menu[$Choice])..." -ForegroundColor Cyan

                & "$PSHOME\powershell.exe" `
                    -NoProfile `
                    -ExecutionPolicy Bypass `
                    -File $ScriptPath

                if ($LASTEXITCODE -ne 0) {
                    Write-Warning "Script returned exit code $LASTEXITCODE."
                }
            }
            else {
                Write-Warning "Script not found: $ScriptPath"
            }
        }
        else {
            switch ($Choice) {
                "9" {
                    Invoke-Item (Join-Path $Root "Reports")
                }

                "10" {
                    Invoke-Item (Join-Path $Root "Logs")
                }

                "11" {
                    Invoke-Item (Join-Path $Root "Backups")
                }

                "0" {
                    Write-Host "Exiting Windows Maintenance Toolkit."
                }

                default {
                    Write-Warning "Invalid selection."
                }
            }
        }
    }
    catch {
        Write-Host "Operation failed: $_" -ForegroundColor Red
    }

    if ($Choice -ne "0") {
        Read-Host "`nPress Enter to return to the main menu" | Out-Null
    }

} while ($Choice -ne "0")
