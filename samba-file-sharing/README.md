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

I tested both accounts by creating, listing and removing test directories in the original configuration. After reinstall, I restored both individual Linux/Samba accounts, verified the primary Windows mapping and completed the two-user access checks. My selected screenshot shows the original tests; I document the later checks in writing.

## Diagnostic procedure

```bash
testparm -s
sudo pdbedit -L
ls -ldZ /srv/storage/shared
sudo journalctl -u smb --no-pager
sudo ausearch -m AVC,USER_AVC -ts recent
```

I review access configuration after reinstallation rather than assuming it is intact. I keep these commands as a repeatable diagnostic procedure.

## Skills I demonstrated

Linux users and groups, SMB authentication, setgid permissions, SELinux diagnostics, and access testing.

## Evidence

[Screenshot gallery](screenshots/README.md).

See [security](../security/README.md) for the related access-control and hardening work.

[Back to project overview](../README.md).
