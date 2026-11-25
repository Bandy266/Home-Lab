# Windows 11 Endpoint Optimization & PowerShell Maintenance Automation

**Independent workstation case study | November 25, 2026 | Changes implemented; acceptance testing in progress**

I optimized my separate Windows 11 gaming and virtualization workstation to reduce unnecessary background activity while preserving security controls and applications I rely on. This is a **Windows endpoint administration project**, not a change to my [Rocky Linux server](../README.md).

## Environment and objective

| Component | Configuration |
| --- | --- |
| Operating system | Windows 11 Pro, build 26200 |
| Processor | AMD Ryzen 9 5900X |
| Graphics | NVIDIA GeForce RTX 3070 Ti |
| Memory | 31.92 GB usable |
| Administration tools | Windows PowerShell 5.1, WinGet, Task Scheduler, DISM, SFC |
| Virtualization | Hyper-V hypervisor detected before and after changes |

My goals were to replace unnecessary resident maintenance utilities with on-demand Windows tooling, reduce background processes and services, maintain a rollback path, and avoid disrupting gaming, virtualization, or endpoint protections.

## PowerShell maintenance toolkit

I created a local toolkit at `C:\Scripts\Windows-Maintenance\` with `Scripts`, `Logs`, `Reports`, and `Backups` directories. `Maintenance.ps1` provides a central menu and an elevated desktop shortcut for on-demand use. Each script passed an **initial functional test**; destructive actions and system repair remain manually initiated.

| Script | Purpose |
| --- | --- |
| `01-System-Audit.ps1` | Collect process, service, OS, hardware, and storage information |
| `02-Storage-Cleanup.ps1` | Perform age-based temporary-file cleanup with confirmation |
| `03-Software-Updates.ps1` | Manage application updates using WinGet |
| `04-System-Health.ps1` | Run DISM and SFC diagnostics and repair |
| `05-Security-Check.ps1` | Inspect Defender, Windows Firewall, and virtualization-based security (VBS) |
| `06-Startup-Audit.ps1` | Inventory startup entries, services, and scheduled tasks |
| `07-Software-Removal.ps1` | Uninstall software through WinGet and inspect leftovers |
| `08-Performance-Report.ps1` | Compare resource baselines and append a historical CSV |

I registered **weekly system and performance audits** plus a **monthly startup audit** in Task Scheduler. The monthly trigger required a native Task Scheduler COM interface workaround after a CIM cmdlet approach failed. The three tasks reported **Ready**; I have not yet confirmed that all scheduled runs execute successfully without intervention.

## Controlled configuration changes

- Removed CCleaner, Advanced SystemCare, IObit Uninstaller, Armoury Crate, and Hamachi. I inspected leftover directories and retained a backup of the identified IObit promotional task before removing it.
- Disabled unused launcher startup entries, NVIDIA Overlay, mobile integration, and Widgets while preserving Discord, OneDrive, Logitech G HUB, SteelSeries Sonar, Riot Vanguard, and Xbox/Game Pass dependencies.
- Disabled **six** unnecessary services, changed **two** to Manual, and exported their previous settings.
- Disabled **nine** scheduled tasks, with individual XML backups available for rollback.
- Kept the Windows **Balanced** power plan rather than applying an unverified aggressive-performance preset.
- Used Group Policy to disable Widgets after a direct registry change was denied; investigated incomplete IObit removal by inspecting the package, processes, services, and tasks.

These were deliberate, reversible changes; I did not disable Hyper-V or essential gaming dependencies to inflate a benchmark result.

## Measurements

I recorded a baseline, a first-stage measurement, and a final post-change report.

| Metric | Original baseline | Phase 1 | Final measurement | Change from baseline |
| --- | ---: | ---: | ---: | ---: |
| Processes | 283 | 256 | **186** | **97 fewer (34.28%)** |
| Running services | 129 | 124 | **109** | **20 fewer (15.50%)** |
| Used RAM | 11.83 GB | 9.61 GB | **6.64 GB** | **5.19 GB less (43.87%)** |
| RAM utilization | 37.07% | 30.11% | **20.79%** | **16.28 percentage points lower** |
| Hypervisor | Active | Active | **Active** | Unchanged |

The temporary-file cleanup reported an additional **192.48 MB** of free space. These are measured endpoint resource counts, **not** claims of increased FPS, faster game loading, or improved VM throughput. Workload differences (including Chrome running during the original snapshot) and reboot state mean the entire reduction cannot be conclusively attributed to the configuration changes alone.

## Security checks and acceptance testing

During toolkit testing, Defender real-time protection, tamper protection, all three Windows Firewall profiles, and VBS Memory Integrity were reported active. Credential Guard itself was **not** reported running. I confirmed that the hypervisor remained active in the final measurement, but did **not** independently test a running Hyper-V guest or its network connectivity.

**Completed:** initial toolkit functional testing, change implementation, backups of affected settings/tasks, resource measurement, Task Scheduler registration, and hypervisor-presence check.

**Still to validate:** actual unattended scheduled-task execution; post-change Defender/firewall/VBS state; Hyper-V guest operations; Game Pass and anti-cheat compatibility; Logitech, SteelSeries Sonar, Discord, and OneDrive workflows; and real gaming FPS/frame-time or VM throughput measurements.

## Evidence and files

My private project report includes two genuine November 25 console captures: an initial baseline and the final PowerShell measurement. I am keeping raw logs, original task XML exports, and service backups **local** while preparing a privacy-reviewed, public evidence selection. See [Evidence and provenance](EVIDENCE.md) for exactly what is—and is not—in this repository.

**Skills demonstrated:** Windows endpoint administration, PowerShell automation, Task Scheduler, change control and rollback planning, startup/service management, security-aware troubleshooting, quantitative resource measurement, and technical documentation.

[Back to Home Lab portfolio](../README.md)
