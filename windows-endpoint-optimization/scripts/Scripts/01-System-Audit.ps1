# Windows Maintenance Toolkit
# Script: 01-System-Audit.ps1
# Purpose: Collect system inventory and resource usage
# Version: 1.0

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Report = "$Root\Reports\System-Audit_$Timestamp.txt"
$Log = "$Root\Logs\System-Audit_$Timestamp.log"

# Publication portability: create private output folders in a fresh checkout.
foreach ($OutputFolder in @("Logs", "Reports", "Backups")) {
    $OutputPath = Join-Path $Root $OutputFolder
    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
}

Start-Transcript -Path $Log | Out-Null

try {
    $OS = Get-CimInstance Win32_OperatingSystem
    $Computer = Get-CimInstance Win32_ComputerSystem
    $CPU = Get-CimInstance Win32_Processor
    $Processes = Get-Process
    $Services = Get-Service

    $Summary = [PSCustomObject]@{
        Timestamp       = Get-Date
        ComputerName    = $env:COMPUTERNAME
        Windows         = $OS.Caption
        Build           = $OS.BuildNumber
        Processor       = ($CPU.Name -join "; ")
        CPUUsage_Pct    = ($CPU | Measure-Object LoadPercentage -Average).Average
        Processes       = $Processes.Count
        RunningServices = ($Services | Where-Object Status -eq "Running").Count
        TotalRAM_GB     = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
        UsedRAM_GB      = [math]::Round(($OS.TotalVisibleMemorySize - $OS.FreePhysicalMemory) / 1MB, 2)
        RAMUsage_Pct    = [math]::Round((1 - $OS.FreePhysicalMemory / $OS.TotalVisibleMemorySize) * 100, 2)
        Hypervisor      = $Computer.HypervisorPresent
        LastBoot        = $OS.LastBootUpTime
    }

    "===== SYSTEM SUMMARY =====" | Out-File $Report
    $Summary | Format-List | Out-String |
        Out-File $Report -Append

    "`n===== PROCESS MEMORY USAGE =====" |
        Out-File $Report -Append

    $Processes |
        Group-Object ProcessName |
        ForEach-Object {
            [PSCustomObject]@{
                Process   = $_.Name
                Instances = $_.Count
                RAM_MB    = [math]::Round(
                    ($_.Group | Measure-Object WorkingSet64 -Sum).Sum / 1MB, 2
                )
            }
        } |
        Sort-Object RAM_MB -Descending |
        Format-Table -AutoSize |
        Out-String -Width 200 |
        Out-File $Report -Append

    "`n===== RUNNING SERVICES =====" |
        Out-File $Report -Append

    $Services |
        Where-Object Status -eq "Running" |
        Select-Object Name, DisplayName, StartType |
        Format-Table -AutoSize |
        Out-String -Width 200 |
        Out-File $Report -Append

    "`n===== STORAGE UTILIZATION =====" |
        Out-File $Report -Append

    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
        Select-Object DeviceID, VolumeName,
            @{N="Total_GB";E={[math]::Round($_.Size / 1GB, 2)}},
            @{N="Free_GB";E={[math]::Round($_.FreeSpace / 1GB, 2)}},
            @{N="Used_Pct";E={[math]::Round((1 - $_.FreeSpace / $_.Size) * 100, 2)}} |
        Format-Table -AutoSize |
        Out-String |
        Out-File $Report -Append

    $Summary | Format-List

    Write-Host "System audit completed successfully." -ForegroundColor Green
    Write-Host "Report: $Report"
    Write-Host "Log:    $Log"
}
catch {
    Write-Host "Audit failed: $_" -ForegroundColor Red
    throw
}
finally {
    Stop-Transcript | Out-Null
}
