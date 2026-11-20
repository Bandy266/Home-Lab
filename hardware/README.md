# Hardware and operating system

## Platform and upgrades

| Component | Configuration |
| --- | --- |
| Chassis | Original Dell PowerEdge T110 |
| CPU | Intel Xeon X3430, 4 cores, 2.40 GHz, x86-64, Intel VT-x |
| Original RAM | Approximately 2 GB installed |
| Upgraded RAM | 16 GB DDR3 ECC UDIMM (4 × 4 GB) |
| OS | Rocky Linux 9.8, reinstalled on a replacement SSD |
| Original OS disk | 320 GB HDD, retired after failure concerns |
| Data drives | Two original 250 GB disks and one replacement 500 GB Seagate ST500DM009 |

The platform was selected for practical experience with existing enterprise hardware. I chose a memory upgrade rather than a CPU replacement; extending the usefulness of the existing machine was more valuable than a small processor upgrade.

## Results and limitations

The 16 GB kit was installed on October 31, 2026. Project records describe `free -h` reporting 15 GiB usable; this is not a memory stress test. The original capture is not included in this public snapshot. The SSD's exact capacity is not asserted here.

The degraded data member was replaced; the two smaller RAID members still limit capacity. See [storage and RAID](../storage-and-raid/README.md) for the recovery and array layout.

## Evidence

The [SMART diagnostic capture](../backup-and-recovery/screenshots/smart-read-failure.png) documents the original data-disk health warning. No standalone RAM image is included.

[Back to project overview](../README.md).
