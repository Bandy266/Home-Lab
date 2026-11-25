# Windows Maintenance Toolkit
# Script: 06-Startup-Audit.ps1
# Purpose: Identify automatic application and service startup
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Log = "$Root\Logs\Startup-Audit_$Timestamp.log"
$Report = "$Root\Reports\Startup-Audit_$Timestamp.txt"

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

try {
    Write-Host "Collecting startup information..." -ForegroundColor Cyan

    $Startup = @(Get-CimInstance Win32_StartupCommand |
        Select-Object Name, Command, Location, User)

    $Services = @(Get-CimInstance Win32_Service |
        Where-Object StartMode -eq "Auto" |
        Select-Object Name, DisplayName, State,
            StartMode, StartName, PathName)

    $Tasks = @(Get-ScheduledTask |
        Where-Object State -ne "Disabled" |
        Select-Object TaskName, TaskPath, State, Author,
            @{N="Actions";E={
                ($_.Actions | ForEach-Object {
                    "$($_.Execute) $($_.Arguments)"
                }) -join "; "
            }})

    $RegistryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce"
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    )

    "===== STARTUP APPLICATIONS =====" | Out-File $Report

    $Startup |
        Format-List |
        Out-String -Width 300 |
        Out-File $Report -Append

    "`n===== AUTOMATIC SERVICES =====" |
        Out-File $Report -Append

    $Services |
        Sort-Object DisplayName |
        Format-List |
        Out-String -Width 300 |
        Out-File $Report -Append

    "`n===== ENABLED SCHEDULED TASKS =====" |
        Out-File $Report -Append

    $Tasks |
        Sort-Object TaskPath, TaskName |
        Format-List |
        Out-String -Width 300 |
        Out-File $Report -Append

    "`n===== STARTUP REGISTRY ENTRIES =====" |
        Out-File $Report -Append

    foreach ($Path in $RegistryPaths) {
        if (Test-Path $Path) {
            "`n$Path" | Out-File $Report -Append

            Get-ItemProperty -Path $Path |
                Select-Object * -ExcludeProperty PS* |
                Format-List |
                Out-String -Width 300 |
                Out-File $Report -Append
        }
    }

    $Startup | Export-Csv `
        "$Root\Reports\Startup-Applications_$Timestamp.csv" `
        -NoTypeInformation -Encoding UTF8

    $Services | Export-Csv `
        "$Root\Reports\Automatic-Services_$Timestamp.csv" `
        -NoTypeInformation -Encoding UTF8

    $Tasks | Export-Csv `
        "$Root\Reports\Scheduled-Tasks_$Timestamp.csv" `
        -NoTypeInformation -Encoding UTF8

    Write-Host "`n===== STARTUP AUDIT SUMMARY =====" -ForegroundColor Cyan

    [PSCustomObject]@{
        StartupApplications = $Startup.Count
        AutomaticServices   = $Services.Count
        RunningAutoServices = @($Services |
            Where-Object State -eq "Running").Count
        EnabledTasks        = $Tasks.Count
    } | Format-List

    Write-Host "Startup audit completed successfully." -ForegroundColor Green
    Write-Host "Report: $Report"
    Write-Host "Log:    $Log"
}
catch {
    Write-Host "Startup audit failed: $_" -ForegroundColor Red
    throw
}
finally {
    Stop-Transcript | Out-Null
}
