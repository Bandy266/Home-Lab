# Windows endpoint optimization — evidence and provenance

**Work date:** November 25, 2026. All measurements below are from the associated Windows endpoint optimization report, not from the Dell PowerEdge T110.

| Evidence | Recorded observation | Publication status |
| --- | --- | --- |
| [Figure W1 — initial PowerShell baseline](screenshots/initial-system-baseline-2026-11-25.png) | 283 processes, 129 running services, 11.83 GB RAM used; hypervisor active | Original embedded screenshot published; [context and caption](screenshots/README.md) |
| [Figure W2 — final PowerShell report](screenshots/final-performance-comparison-2026-11-25.png) | 186 processes, 109 running services, 6.64 GB RAM used; hypervisor active | Original embedded screenshot published; [context and caption](screenshots/README.md) |
| `Original-Baseline.json` | Original resource snapshot | Kept on the Windows workstation, not published |
| `Performance-History.csv` | Historical measurements | Kept on the Windows workstation, not published |
| `Performance-Report_2026-11-25_10-48-29.txt` | Final resource report | Kept on the Windows workstation, not published |
| Service settings and scheduled-task XML exports | Rollback records | Kept private |
| PowerShell toolkit source (menu and eight modules) | Reviewed copies of the code used for the maintenance toolkit | [Published in this repository](scripts/README.md); generated logs, reports, backups and baseline remain private |

The underlying records are stored under `C:\Scripts\Windows-Maintenance\`, particularly the `Reports` and `Backups` subdirectories. The companion source document is titled `Windows_Endpoint_Optimization_Portfolio_2026-11-25.docx`.

I have now published the two PNG images extracted from the Word report's evidence appendix in the [screenshot gallery](screenshots/README.md). They contain the cropped console output shown in my original report. I did not alter the extracted image pixels. This publication does **not** include raw machine-generated reports, baseline JSON, configuration backups, or additional post-optimization tests. I make no claim of completed Hyper-V guest, gaming frame-time/FPS, or unattended scheduling acceptance tests.

[Read the case study](README.md) · [Back to main evidence index](../EVIDENCE.md)
