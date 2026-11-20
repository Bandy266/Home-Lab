# Backup and recovery

## Incident and objective

Disk-health concerns led to a planned replacement of the original OS drive and a degraded RAID data member. The objective was to protect configuration and data while restoring a usable Rocky Linux server, without unnecessarily recreating the existing RAID/XFS filesystem.

## Backup preparation performed

- Prepared the compressed system archive `t110-system-backup.tar.gz` (approximately 455 MiB) and a separate RAID configuration backup.
- Inspected the archive listing and copied the archive to Windows.
- Compared source and transferred-copy SHA-256 checksums; the recorded values matched.
- Checked five inventory/export scripts covering system information, Samba, storage, networking and RAID inspection.

The archive inspection and matching hashes verified backup readability at the listing level and transfer integrity. The recovery itself was carried out separately, retaining the existing XFS filesystem.

## Recovery activities performed

1. Replaced the original OS HDD with an SSD and reinstalled Rocky Linux 9.8.
2. Replaced a degraded array member with a 500 GB drive and rebuilt the existing three-member RAID 5.
3. Investigated degraded assembly after an initial reboot, corrected the replacement member metadata, rebuilt the array and verified successful assembly on a subsequent reboot. The October 16 recovery log records `[3/3] [UUU]` and the XFS mount.
4. Restored access to the existing XFS mount, static network configuration, SSH and Cockpit.
5. Restored both individual Linux/Samba accounts and the Household share. The primary Windows mapping was confirmed working; the project owner subsequently confirmed the post-reinstall user access and security checks.

## Validation status

| Check | Status |
| --- | --- |
| Backup archive inspection and transferred-copy SHA-256 verification | Completed; matching checksums |
| OS and degraded RAID disk replacement | Completed |
| RAID 5 rebuild and XFS mount | Recovered |
| Post-fix reboot assembly | Passed; October 16 recovery log records `[3/3] [UUU]` and mounted XFS |
| Backup-assisted system recovery and restored storage access | Completed; recovery recorded and confirmed by project owner |
| Linux/Samba accounts, Household access, SSH and Cockpit | Restored |
| Post-reinstall two-user access and security checks | Completion confirmed by project owner; individual test outputs not reproduced |

The screenshot gallery documents the disk fault that prompted recovery. The October 16 written recovery record and subsequent owner confirmation document the outcome. This release does not reproduce the original backup archives, a standalone per-file comparison report, or credential-bearing configuration.

## Lessons learned

Keep a verified independent backup, distinguish checksum verification from restore testing, preserve UID/GID and permissions when restoring services, and verify array assembly following reboot.

## Evidence

[Screenshot gallery](screenshots/README.md).

Related historical evidence: [healthy RAID and XFS](../storage-and-raid/screenshots/raid5-xfs-baseline.png), [network and service checks](../networking/screenshots/static-ip-and-gateway-test.png), [original two-account Samba tests](../samba-file-sharing/screenshots/selinux-and-two-user-write-tests.png).

[Back to project overview](../README.md).
