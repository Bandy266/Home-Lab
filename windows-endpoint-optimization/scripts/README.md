# PowerShell Maintenance Toolkit — Source Code

**Project:** [Windows 11 endpoint optimization](../README.md) | **Implementation:** November 25, 2026
**Shell:** Windows PowerShell 5.1 | **Environment:** Windows 11 Pro | **Status:** Initial function tests completed; scheduled unattended execution and broader compatibility acceptance tests pending.

I built this interactive maintenance toolkit to replace unnecessary resident optimization utilities with native Windows administration tools. The nine PowerShell files below are based on my workstation implementation. **For portability, I added one small safeguard to these publication copies:** the menu and each module create their own `Logs`, `Reports`, and `Backups` folders if those folders are missing. The originals on my workstation were not modified.

## Contents

| File | Purpose | Interaction and potential impact |
| --- | --- | --- |
| [`Maintenance.ps1`](Maintenance.ps1) | Elevated launcher and numbered menu | Requires administrator session; invokes selected modules |
| [`01-System-Audit.ps1`](Scripts/01-System-Audit.ps1) | OS, processor, process, service and disk usage inventory | Read-only; writes local reports and transcript logs |
| [`02-Storage-Cleanup.ps1`](Scripts/02-Storage-Cleanup.ps1) | Find temporary files older than seven days | **Deletes files only after explicit confirmation**; verify candidate scope before use |
| [`03-Software-Updates.ps1`](Scripts/03-Software-Updates.ps1) | List and install WinGet application updates | Specific and bulk updates require confirmation |
| [`04-System-Health.ps1`](Scripts/04-System-Health.ps1) | DISM and SFC integrity checks and repairs | Repair operations require confirmation; can change system files |
| [`05-Security-Check.ps1`](Scripts/05-Security-Check.ps1) | Defender, Firewall and VBS inspection, updates and scans | Read-only options plus user-initiated signature update and scans |
| [`06-Startup-Audit.ps1`](Scripts/06-Startup-Audit.ps1) | Startup entries, automatic services, scheduled tasks | Read-only; exported details may contain personal paths or sensitive command arguments |
| [`07-Software-Removal.ps1`](Scripts/07-Software-Removal.ps1) | WinGet app identification, removal and leftover inspection | **Uninstall requires confirmation**; leftover inspection does not delete files |
| [`08-Performance-Report.ps1`](Scripts/08-Performance-Report.ps1) | Compare current resources with original baseline and append CSV | Requires a **private** `Reports/Original-Baseline.json` created separately during testing |

## Local use

1. Download or clone the repository on a **Windows** computer. Review the code before executing it.
2. From Windows PowerShell 5.1, open the `scripts` directory. For the full menu, launch an administrator PowerShell session and run `.\Maintenance.ps1` (shown below).
3. The tools create `Logs`, `Reports`, and `Backups` beside the menu; these directories are ignored by Git and should **not be committed**.
4. Only enable a repair, uninstall, update, or cleanup option if it is appropriate for the computer you are administering.

```powershell
Set-Location '.\windows-endpoint-optimization\scripts'
.\Maintenance.ps1
```

The menu requests elevation but **does not automatically elevate itself**. It launches selected modules in another Windows PowerShell process with a process-scoped `-ExecutionPolicy Bypass` argument, as configured in my original toolkit. That flag does not confer administrator rights; review trust and execution policies before adapting this launcher for other environments.

### Performance baseline dependency

`08-Performance-Report.ps1` reads `Reports/Original-Baseline.json`, which is intentionally **not** published. The local JSON needs numeric properties `Processes`, `RunningServices`, `UsedRAM_GB`, and `RAMUsage_Pct`, plus `Hypervisor` for its status comparison. I have not substituted simulated measurements for my recorded baseline. Without a locally supplied baseline, the script stops with a clear missing-file error.

### Safety and evidence boundaries

- The source files contain **no embedded personal email addresses, passwords, API tokens, or static user-profile paths** in this submitted snapshot. They still generate reports that can reveal such information; keep runtime outputs private.
- These are administration tools, not a claimed security benchmark or a generalized safe optimization preset. Some operations require elevated permissions and can affect software and system state.
- I performed initial functional tests on my workstation; I have **not** independently proven unattended Task Scheduler execution, all post-change application compatibility, a full Hyper-V guest test, or FPS/VM throughput gains.
- The case study's before-and-after measurements came from my local report and are not re-created or independently revalidated by the published source alone.

[Read my Windows endpoint case study](../README.md) · [Evidence index](../EVIDENCE.md) · [Main portfolio](../../README.md)
