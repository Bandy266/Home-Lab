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

An original member showed a SMART read-test failure and a bad sector. I replaced the degraded disk and rebuilt the existing array rather than creating a new filesystem. A reboot during recovery exposed a degraded array; I investigated the replacement member metadata, corrected the issue and rebuilt the array. I verified successful assembly on a subsequent reboot, as recorded in my October 16 recovery log, and retained the original XFS mount and file-sharing path.

My original array screenshot shows `[3/3] [UUU]`, `df -hT`, and the mounted filesystem. My October 16 written recovery log records successful post-fix reboot assembly (`[3/3] [UUU]`) and the XFS mount. I also recorded a healthy array on October 31. My baseline image illustrates the original configuration; my written records cover the later reboot test.

## Repeatable inspection procedure

I use the following read-only commands for repeatable storage inspection:

```bash
lsblk -f
cat /proc/mdstat
sudo mdadm --detail /dev/md0
findmnt /srv/storage
df -hT /srv/storage
```

My recovery approach prioritizes confirming drive identity, protecting the existing filesystem, and checking array state before any destructive operation.

## Skills I demonstrated

Software RAID, storage diagnostics, XFS mount inspection, disk replacement, troubleshooting and recovery planning.

## Evidence

[Screenshot gallery](screenshots/README.md).

See [backup and recovery](../backup-and-recovery/README.md) for the backup and rebuild sequence.

[Back to project overview](../README.md).
