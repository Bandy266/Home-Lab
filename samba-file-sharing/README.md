# Samba file sharing

## Configuration

| Item | Configuration |
| --- | --- |
| Share | `Household` |
| Directory | `/srv/storage/shared` |
| Access group | `fileshare` |
| Filesystem | XFS on `/dev/md0` |
| Historical ownership and mode | `root:fileshare`, `2770` (setgid) |
| Authentication | Individual Samba accounts |

I configured two household users with individual Linux and Samba accounts and group-based access. The setgid bit helps newly created files and directories inherit the shared group; the full access policy also depends on Samba configuration and SELinux.

## Troubleshooting case: SELinux access denial

The share was initially inaccessible. I investigated the Samba journal and audit denials, found an incorrect filesystem context, configured an appropriate persistent Samba file context, and applied it using `restorecon`. I verified `samba_share_t` on the storage path and tested the share with `smbclient`.

The original captured tests show both accounts creating, listing and removing test directories. The tests demonstrate successful write operations in the pre-reinstallation configuration. Later project records confirm access through the primary user's Windows mapping after reinstall; another complete two-user test was not captured.

## Diagnostic procedure

```bash
testparm -s
sudo pdbedit -L
ls -ldZ /srv/storage/shared
sudo journalctl -u smb --no-pager
sudo ausearch -m AVC,USER_AVC -ts recent
```

Access configuration should be reviewed after reinstall rather than assumed intact. The procedure above is not a new execution transcript.

## Skills demonstrated

Linux users and groups, SMB authentication, setgid permissions, SELinux diagnostics, and access testing.

## Evidence

[Screenshot gallery](screenshots/README.md).

See [security](../security/README.md) for the related access-control and hardening work.

[Back to project overview](../README.md).
