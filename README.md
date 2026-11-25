# Rocky Linux Home Lab | Dell PowerEdge T110

**Linux system administration · Storage and disaster recovery · Network services · Security**

I built and administer a Rocky Linux home server to develop practical IT and cybersecurity skills. I deployed network file storage, troubleshot access and disk failures, recovered services after hardware replacement, and documented my results with technical evidence.

## Project at a glance

| Component | Configuration |
| --- | --- |
| Server | Dell PowerEdge T110 (first generation) |
| Processor | Intel Xeon X3430, 4 cores, 2.40 GHz |
| Memory | 16 GB DDR3 ECC UDIMM; upgrade recorded October 31, 2026 |
| Operating system | Rocky Linux 9.8 on replacement SSD |
| Data storage | Three-member software RAID 5, XFS, approximately 465 GiB usable |
| Administration | SSH, Cockpit, systemd, NetworkManager |
| File sharing and security | Samba, Linux group permissions, SELinux, firewalld |

## Architecture

```text
Existing local network (router settings unchanged)
     |
     +-- Windows client: SSH / Cockpit / SMB
     |
     +-- Rocky Linux server (static IPv4, eno1)
          |-- OS: replacement SSD
          |-- mdadm RAID 5: /dev/md0
          |    `-- XFS: /srv/storage
          |         `-- shared: Samba Household
          `-- Access: individual accounts, fileshare group, SELinux, firewalld
```

## My accomplishments

- Installed Rocky Linux, configured remote administration, and upgraded the server to 16 GB ECC memory.
- Prepared a system backup before replacing a failing OS drive and a degraded RAID member; inspected the archive and verified the transferred copy with SHA-256.
- Reinstalled the operating system and rebuilt the existing RAID 5 array without deliberately recreating the XFS filesystem; resolved a reboot-related RAID assembly issue and restored access to the shared filesystem, Samba and administrative services.
- Resolved Samba access failures by investigating SELinux denials and correcting file contexts; demonstrated two-account read/write access and restored the individual user accounts and Samba access after reinstall.
- Configured static IPv4 using NetworkManager and verified the gateway route and allowed services.
- Validated key-based SSH and password rejection, inspected effective SSH settings, and removed unused RPC services during the initial security-hardening work.

## Technical documentation

| Section | What it demonstrates |
| --- | --- |
| [Hardware](hardware/README.md) | Hardware selection, SSD and RAM upgrades |
| [Linux administration](linux-administration/README.md) | SSH, Cockpit, diagnostics, systemd and service verification |
| [Networking](networking/README.md) | DHCP-to-static configuration, connectivity and troubleshooting |
| [Storage and RAID](storage-and-raid/README.md) | Software RAID, XFS, drive replacement and recovery |
| [Samba file sharing](samba-file-sharing/README.md) | Authentication, permissions and SELinux troubleshooting |
| [Security](security/README.md) | SSH hardening, least privilege and service exposure |
| [Backup and recovery](backup-and-recovery/README.md) | Backup integrity checks, OS reinstall, RAID recovery and restored services |
| [Evidence index](EVIDENCE.md) | Screenshot provenance and what each capture proves |

## Additional project: Windows workstation optimization (November 25, 2026)

I also completed a separate Windows 11 endpoint optimization and PowerShell maintenance automation project on my Ryzen 9 5900X gaming/virtualization workstation. I built an eight-script maintenance toolkit, backed up service and task settings, registered routine audits, and recorded the following resource changes: **283 → 186 processes**, **129 → 109 running services**, and **11.83 → 6.64 GB of used RAM**. I retained Hyper-V and required gaming software. Final compatibility and unattended-task acceptance tests remain outstanding; the numbers are resource measurements, not proven FPS improvements.

[Read my Windows 11 optimization case study](windows-endpoint-optimization/README.md) · [Evidence and limitations](windows-endpoint-optimization/EVIDENCE.md)

## Verification and scope

For the Rocky Linux server, I documented my core infrastructure work through November 2, 2026. I distinguish screenshots from the original configuration from my later recovery records, including the October 31 RAM/RAID check, which I describe in writing. This edition focuses on infrastructure rather than application hosting.

I completed the recovery in October 2026. My October 16 recovery log records successful RAID assembly after reboot, and I completed the post-reinstall access and recovery checks. My screenshots illustrate selected tests, supplemented by my written recovery records. I verified archive transfer integrity with SHA-256; this edition does not include a separate itemized file-by-file comparison report. My future work includes virtualization.

## Author

Austin Bandy — personal IT and cybersecurity home lab project.
