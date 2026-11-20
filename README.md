# Rocky Linux Home Lab | Dell PowerEdge T110

**Linux system administration · Storage and disaster recovery · Network services · Security**

I built and administer a Rocky Linux home server to develop practical IT and cybersecurity skills. The project includes deploying network file storage, troubleshooting access and disk failures, recovering services after a hardware replacement, and documenting results with real technical evidence.

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

## Selected accomplishments

- Installed Rocky Linux, configured remote administration, and upgraded the server to 16 GB ECC memory.
- Prepared a system backup before replacing a failing OS drive and a degraded RAID member; inspected the archive and verified the transferred copy with SHA-256.
- Reinstalled the operating system and rebuilt the existing RAID 5 array without deliberately recreating the XFS filesystem; restored access to the shared filesystem and administrative services.
- Resolved Samba access failures by investigating SELinux denials and correcting file contexts; demonstrated two-account read/write access in the original configuration.
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
| [Backup and recovery](backup-and-recovery/README.md) | Backup preparation, OS reinstall, RAID recovery and validation limits |
| [Evidence index](EVIDENCE.md) | Screenshot provenance and what each capture proves |

## Verification and scope

This release focuses on the core infrastructure work recorded through November 2, 2026. Screenshots from the original configuration are distinguished from later recovery records. The October 31 RAM/RAID capture is described in the project records but is not included here as an image. Application-hosting work is outside this edition.

A complete independent backup-restore test, a separate final post-fix RAID reboot transcript, and a comprehensive post-reinstall security and two-user access retest are not claimed. Future work includes additional validation and virtualization.

## Author

Austin Bandy — personal IT and cybersecurity home lab project.
