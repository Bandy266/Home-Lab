# Windows Maintenance Toolkit
# Script: 05-Security-Check.ps1
# Purpose: Windows security monitoring and maintenance
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\Security-Check_$Timestamp.log"

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

try {
    do {
        Write-Host "`n===== SECURITY CHECK =====" -ForegroundColor Cyan
        Write-Host "1. Microsoft Defender status"
        Write-Host "2. Update security definitions"
        Write-Host "3. Quick malware scan"
        Write-Host "4. Full malware scan"
        Write-Host "5. Review detected threats"
        Write-Host "6. Windows Firewall status"
        Write-Host "7. Credential Guard and VBS status"
        Write-Host "8. Exit"

        $Choice = Read-Host "Select an option"

        try {
            switch ($Choice) {
                "1" {
                    Get-MpComputerStatus |
                    Select-Object AMRunningMode,
                        AMServiceEnabled,
                        AntivirusEnabled,
                        AntispywareEnabled,
                        RealTimeProtectionEnabled,
                        BehaviorMonitorEnabled,
                        IoavProtectionEnabled,
                        NISEnabled,
                        IsTamperProtected,
                        AntivirusSignatureVersion,
                        AntivirusSignatureLastUpdated,
                        QuickScanEndTime,
                        FullScanEndTime |
                    Format-List
                }

                "2" {
                    Update-MpSignature
                    Write-Host "Definition update completed." -ForegroundColor Green
                }

                "3" {
                    if ((Read-Host "Start quick scan? (Y/N)") -eq "Y") {
                        Start-MpScan -ScanType QuickScan
                        Write-Host "Quick scan command completed." -ForegroundColor Green
                    }
                }

                "4" {
                    if ((Read-Host "Start full scan? (Y/N)") -eq "Y") {
                        Start-MpScan -ScanType FullScan
                        Write-Host "Full scan command completed." -ForegroundColor Green
                    }
                }

                "5" {
                    $Threats = @(Get-MpThreatDetection)

                    if ($Threats.Count -eq 0) {
                        Write-Host "No threat detection records returned." -ForegroundColor Green
                    }
                    else {
                        $Threats | Format-List
                    }
                }

                "6" {
                    Get-NetFirewallProfile -PolicyStore ActiveStore |
                    Select-Object Name,
                        Enabled,
                        DefaultInboundAction,
                        DefaultOutboundAction |
                    Format-Table -AutoSize
                }

                "7" {
                    Get-CimInstance `
                        -Namespace "root\Microsoft\Windows\DeviceGuard" `
                        -ClassName Win32_DeviceGuard |
                    Select-Object VirtualizationBasedSecurityStatus,
                        SecurityServicesConfigured,
                        SecurityServicesRunning,
                        AvailableSecurityProperties |
                    Format-List

                    Write-Host "VBS status: 0 = Disabled, 1 = Enabled but not running, 2 = Running"
                    Write-Host "Security service 1 = Credential Guard"
                    Write-Host "Security service 2 = Memory Integrity"
                }

                "8" {
                    Write-Host "Exiting security check."
                }

                default {
                    Write-Host "Invalid selection." -ForegroundColor Yellow
                }
            }
        }
        catch {
            Write-Host "Operation failed: $_" -ForegroundColor Red
        }

    } while ($Choice -ne "8")
}
finally {
    Write-Host "Log: $Log"
    Stop-Transcript | Out-Null
}
