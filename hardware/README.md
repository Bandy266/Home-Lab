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

I selected this platform to gain practical experience with existing enterprise hardware. I chose a memory upgrade rather than a CPU replacement; extending the usefulness of the existing machine was more valuable than a small processor upgrade.

## Results and limitations

I installed the 16 GB kit on October 31, 2026 and recorded `free -h` reporting 15 GiB usable. This verified recognized memory capacity, not memory stress-test results. I documented the check in my project records; the original image is not included in this edition.

I replaced the degraded data member; the two smaller RAID members still limit capacity. See [storage and RAID](../storage-and-raid/README.md) for the recovery and array layout.

## Evidence

The [SMART diagnostic capture](../backup-and-recovery/screenshots/smart-read-failure.png) documents the original data-disk health warning. My RAM upgrade is documented in writing in this edition.

[Back to project overview](../README.md).
