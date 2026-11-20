# Linux system administration

## Operating environment

I run Rocky Linux 9.8 on the replacement SSD and use SSH to administer the server from Windows and Cockpit for web-based monitoring, with systemd for service management and NetworkManager for network configuration.

## Administration tasks

- Configured key-based SSH and a client-side `homeserver` alias; tested an independent login before relying on the hardening settings.
- Inspected processor, memory, filesystem and network status; used Cockpit to identify a disk-health concern.
- Investigated listening services, used systemd to inspect and manage services, and removed unused RPC services after checking for NFS usage.
- Restored SSH, Cockpit and Samba following the OS reinstall, including both individual user accounts and the primary Windows share mapping.

My service audit capture shows that RPC-related units became inactive and SSH, SMB and Cockpit socket services remained active. My SSH capture shows key-based login and password-only rejection in the historical configuration.

## Useful inspection commands

```bash
cat /etc/os-release
free -h
lsblk -f
systemctl is-active sshd smb cockpit.socket
ss -tulnp
nmcli device status
```

I keep these commands as repeatable diagnostics for future administration.

## Skills I demonstrated

Shell administration, SSH authentication, Cockpit monitoring, systemd service management, diagnostic interpretation and recovery.

## Evidence

[Screenshot gallery](screenshots/README.md).

Related evidence: [SMART warning](../backup-and-recovery/screenshots/smart-read-failure.png), [RAID baseline](../storage-and-raid/screenshots/raid5-xfs-baseline.png), [SSH hardening](../security/screenshots/effective-ssh-hardening.png).

[Back to project overview](../README.md).
