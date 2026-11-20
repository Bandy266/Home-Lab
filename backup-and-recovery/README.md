# Backup and recovery

## Incident and objective

Disk-health concerns led to a planned replacement of the original OS drive and a degraded RAID data member. The objective was to protect configuration and data while restoring a usable Rocky Linux server, without unnecessarily recreating the existing RAID/XFS filesystem.

## Backup preparation performed

- Prepared the compressed system archive `t110-system-backup.tar.gz` (approximately 455 MiB) and a separate RAID configuration backup.
- Inspected the archive listing and copied the archive to Windows.
- Compared source and transferred-copy SHA-256 checksums; the recorded values matched.
- Checked five inventory/export scripts covering system information, Samba, storage, networking and RAID inspection.

Archive listing and matching hashes establish that the archive listing was readable and the transferred copy matched; they do not establish complete coverage or a successful independent restore.

## Recovery activities performed

1. Replaced the original OS HDD with an SSD and reinstalled Rocky Linux 9.8.
2. Replaced a degraded array member with a 500 GB drive and rebuilt the existing three-member RAID 5.
3. Investigated degraded assembly after an initial reboot; the array was subsequently reported operational.
4. Restored access to the existing XFS mount, static network configuration, SSH and Cockpit.
5. Restored the Household share and confirmed the primary user's Windows mapping worked after reinstall.

## Validation status

| Check | Status |
| --- | --- |
| Archive listing and transferred-copy checksum | Recorded completed |
| OS and degraded RAID disk replacement | Recorded completed |
| Existing RAID/XFS and primary Windows share access | Recorded recovered |
| Final post-fix reboot persistence | Separate transcript not included |
| Complete independent backup restore and file comparison | Not documented |
| Both users' post-reinstall read/write tests and full security revalidation | Not separately evidenced |

The screenshot gallery shows historical evidence of the disk fault, not a full restore test. Backup archives and credential-bearing configuration are not distributed in this public release.

## Lessons learned

Keep a verified independent backup, distinguish checksum verification from restore testing, preserve UID/GID and permissions when restoring services, and verify array assembly following reboot.

## Evidence

[Screenshot gallery](screenshots/README.md).

Related historical evidence: [healthy RAID and XFS](../storage-and-raid/screenshots/raid5-xfs-baseline.png), [network and service checks](../networking/screenshots/static-ip-and-gateway-test.png), [original two-account Samba tests](../samba-file-sharing/screenshots/selinux-and-two-user-write-tests.png).

[Back to project overview](../README.md).
