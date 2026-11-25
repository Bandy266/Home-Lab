# Evidence index

I selected these original captures from my home lab records. They show the configurations and results at the time of each test. I cropped irrelevant borders and masked personal identifiers or unnecessary device details for publication; the technical output remains authentic. I retain the originals in my private working repository.

| Capture | What it demonstrates | Public preparation |
| --- | --- | --- |
| [raid5-xfs-baseline.png ](storage-and-raid/screenshots/raid5-xfs-baseline.png) | Historical mdstat: [3/3] [UUU], XFS and the mounted /srv/storage filesystem; the October 16 post-fix reboot result is recorded separately in the written recovery log. | Cropped |
| [smart-read-failure.png ](backup-and-recovery/screenshots/smart-read-failure.png) | Historical SMART failed read self-test and one bad sector on /dev/sdd; reason for recovery planning. | Cropped; identifiers masked |
| [static-ip-and-gateway-test.png ](networking/screenshots/static-ip-and-gateway-test.png) | Historical manual IPv4 configuration, route inspection, four successful gateway replies and allowed services. Private RFC1918 LAN addresses are retained. | Cropped |
| [shared-directory-permissions.png ](samba-file-sharing/screenshots/shared-directory-permissions.png) | Historical fileshare group, root:fileshare ownership, setgid 2770 and directory inspection. | Cropped |
| [selinux-and-two-user-write-tests.png ](samba-file-sharing/screenshots/selinux-and-two-user-write-tests.png) | Historical SELinux context correction and creation/listing/removal of test directories by two SMB accounts; identities masked; original configuration tests; I completed later access checks. | Cropped; identifiers masked |
| [ssh-key-login-and-password-rejection.png ](linux-administration/screenshots/ssh-key-login-and-password-rejection.png) | Historical successful SSH key login and refused password-only login; local account names and client key path masked. | Cropped; identifiers masked |
| [effective-ssh-hardening.png ](security/screenshots/effective-ssh-hardening.png) | Historical sshd -T output showing three authentication attempts, root and password login disabled, keyboard-interactive and X11 forwarding disabled; public key authentication shown enabled in earlier output. | Cropped; identifiers masked |
| [rpc-service-audit.png ](linux-administration/screenshots/rpc-service-audit.png) | Historical removal of unused RPC service/socket, inactive status and active SSH, SMB and Cockpit socket verification. | Cropped; identifiers masked |

The private RFC1918 addressing shown in the LAN evidence is not a public WAN address. I documented the RAM/RAID follow-up in my written records; the original capture is not included here. My October 16 recovery log records a successful post-fix RAID reboot, and I completed subsequent recovery, user-access and security checks. This edition does not include a standalone itemized file-comparison report or later security command transcript.

## Additional Windows workstation evidence

I documented a separate November 25 Windows endpoint optimization in my [Windows case study](windows-endpoint-optimization/README.md). Its [evidence index](windows-endpoint-optimization/EVIDENCE.md) records the original and final measurements and explains which underlying captures and reports are retained privately rather than included as public image files.

[Back to project overview](README.md).
