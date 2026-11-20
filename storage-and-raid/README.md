# Storage and RAID

## Architecture

| Item | Configuration |
| --- | --- |
| RAID | Three-member RAID 5, software-managed with `mdadm` |
| Device | `/dev/md0` |
| Filesystem | XFS |
| Mount | `/srv/storage` |
| Capacity | Approximately 465 GiB (roughly 500 GB decimal) |
| Member sizes | Two original 250 GB drives; one replacement 500 GB drive |

RAID 5 distributes parity across members and can tolerate one member failure under suitable conditions. The larger replacement drive does not expand usable capacity while smaller members remain. RAID is not a substitute for independent backups.

## Troubleshooting and recovery

An original member showed a SMART read-test failure and a bad sector. I replaced the degraded disk and rebuilt the existing array rather than creating a new filesystem. A reboot during recovery exposed a degraded array; I investigated it and later confirmed the server was operating. The original XFS mount and file-sharing path were retained.

The historical array screenshot shows `[3/3] [UUU]`, `df -hT`, and the mounted filesystem. Later project records describe healthy RAID on October 31, but the separately dated final post-fix reboot transcript and complete file-content comparison are not part of this release.

## Repeatable inspection procedure

The following are read-only inspection commands, not a fresh execution log:

```bash
lsblk -f
cat /proc/mdstat
sudo mdadm --detail /dev/md0
findmnt /srv/storage
df -hT /srv/storage
```

The recovery approach prioritizes confirming drive identity, protecting the existing filesystem, and checking array state before any destructive operation.

## Skills demonstrated

Software RAID, storage diagnostics, XFS mount inspection, disk replacement, troubleshooting and recovery planning.

## Evidence

[Screenshot gallery](screenshots/README.md).

See [backup and recovery](../backup-and-recovery/README.md) for the backup and rebuild sequence.

[Back to project overview](../README.md).
