# Tailscale Setup

Tailscale is used for secure remote access between all devices — server, local machine, and iPad — without exposing anything to the public internet.

---

## Initial Setup

Install and enable on the server:

```bash
sudo pacman -S tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up
```

Authenticate via the URL it prints. Once done:

```bash
tailscale status   # see all connected devices
tailscale ip       # get this machine's Tailscale IP (100.x.x.x)
```

---

## Current Devices

| Device | Tailscale IP | Notes |
|---|---|---|
| sarang-hp (server) | 100.100.208.10 | Always-on, SSH target |
| ipad-9th-gen-wifi | 100.82.110.84 | Termius SSH client |
| local machine | — | SSH + SSHFS |

---

## Adding a New Device

Install Tailscale on the new device and run:

```bash
sudo tailscale up
```

It will open a browser to authenticate with your Tailscale account. Once authenticated it appears in `tailscale status` on all other devices automatically.

---

## Connecting via Tailscale IP

Use the server's Tailscale IP (`100.100.208.10`) from any device not on the same local network:

```bash
ssh sarang@100.100.208.10
```

Or if `~/.ssh/config` is set up, just `ssh hp-server` works from anywhere.

---

## Troubleshooting

**Tailscale shows device as offline:**
```bash
sudo tailscale up          # re-authenticate if needed
sudo systemctl restart tailscaled
tailscale status
```

**Can't reach server via Tailscale IP:**
```bash
tailscale ping 100.100.208.10   # test connectivity
```

If ping fails, check that `tailscaled` is running on both devices:
```bash
sudo systemctl status tailscaled
```

**Re-authenticate (token expired):**
```bash
sudo tailscale up --force-reauth
```

**Reset and start fresh:**
```bash
sudo tailscale up --reset
```

---

## Notes

- Tailscale IPs (`100.x.x.x`) are stable per device — they don't change unless you remove and re-add the device
- No ports need to be opened on the router; Tailscale handles NAT traversal
- SSH hardening (`PasswordAuthentication no`) still applies over Tailscale — key auth only
