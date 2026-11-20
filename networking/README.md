# Networking and connectivity

## Configuration

| Component | Configuration |
| --- | --- |
| Interface | `eno1` |
| Network manager | NetworkManager |
| Addressing | Static IPv4 on a private /24 LAN (historically DHCP) |
| Gateway and DNS | Existing LAN gateway |
| Remote administration | SSH (`homeserver` client shortcut) and Cockpit |
| File sharing | SMB using Samba |

I confirmed the existing network configuration and preserved the router settings. No router administration changes are claimed.

## Troubleshooting

The initial system used DHCP. I investigated interface state, corrected NetworkManager command syntax, checked candidate addresses using ping and ARP, and configured manual IPv4 settings for the server. The retained historical screenshot shows the static address, default route, four received gateway replies with 0% packet loss, and firewall allowed-service inspection.

An unanswered ARP or ICMP probe is not a guarantee that a future DHCP conflict cannot occur. The project's addressing plan should be reviewed if the DHCP scope changes.

## Repeatable diagnostics

```bash
nmcli device status
nmcli connection show
ip -4 addr show eno1
ip route
sudo firewall-cmd --list-services
```

These commands are an inspection procedure; the attached capture records the original test. RFC1918 addresses remain visible in the selected capture. No public WAN address or router-specific identification is included.

## Skills demonstrated

IPv4 addressing, DHCP versus static configuration, route inspection, connectivity testing, NetworkManager and service exposure checks.

## Evidence

[Screenshot gallery](screenshots/README.md).



[Back to project overview](../README.md).
