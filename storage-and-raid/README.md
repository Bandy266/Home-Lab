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

An original member showed a SMART read-test failure and a bad sector. I replaced the degraded disk and rebuilt the existing array rather than creating a new filesystem. A reboot during recovery exposed a degraded array; I investigated the replacement member metadata, corrected the issue and rebuilt the array. The October 16 recovery log records a successful subsequent reboot with all three members active. The original XFS mount and file-sharing path were retained.

The historical array screenshot shows `[3/3] [UUU]`, `df -hT`, and the mounted filesystem. The October 16 written recovery log records successful post-fix reboot assembly (`[3/3] [UUU]`) and the XFS mount. The October 31 follow-up also records a healthy array. The included baseline image illustrates the original configuration rather than the later reboot test.

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
