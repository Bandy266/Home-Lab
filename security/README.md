# Security administration

## Security controls implemented in the original configuration

- Used individual accounts and the `fileshare` group rather than anonymous shared access.
- Configured SSH public-key authentication and a passphrase-protected client key.
- Disabled SSH root login, password authentication, keyboard-interactive authentication, and X11 forwarding; reduced maximum authentication attempts to three.
- Verified effective SSH configuration and tested a password-only login rejection.
- Inspected listening services, reviewed firewall allowed services, and disabled unnecessary RPC services after checking for NFS usage.
- Corrected SELinux contexts for Samba access rather than disabling SELinux.

## Verification

My selected SSH capture shows effective settings in the original installation. The [SSH login test](../linux-administration/screenshots/ssh-key-login-and-password-rejection.png) shows public-key authentication succeeding and a password-only attempt being rejected. The [service audit](../linux-administration/screenshots/rpc-service-audit.png) records inactive RPC units after disabling them and active SSH, Samba and Cockpit socket services. The [Samba case study](../samba-file-sharing/README.md) documents security-context troubleshooting.

## After the reinstall

I restored SSH remote access, Cockpit, Windows file sharing and both individual Linux/Samba accounts after the OS recovery. I completed the post-reinstall security checks. My screenshots document the original hardening implementation; I describe the later checks in writing.

I use read-only security checks such as `sshd -T`, `getenforce`, `firewall-cmd --list-all`, `ss -tulnp`, and `systemctl is-active`. I check service requirements before making firewall or service changes.

## Skills I demonstrated

Authentication hardening, least privilege, SELinux access control, firewall/service inspection and documenting validation boundaries.

## Evidence

[Screenshot gallery](screenshots/README.md).

[Back to project overview](../README.md).
