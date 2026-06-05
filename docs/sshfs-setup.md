# SSHFS Setup Guide (Arch Linux ↔ Arch Linux)

This guide explains how to mount a directory from a remote Arch Linux server as a local folder using SSHFS.

---

# Overview

SSHFS (SSH Filesystem) allows you to access files on a remote machine as if they were stored locally.

Example:

```text
Remote Server (hp-server / sarang-hp)
└── /home/sarang

Local Machine (sarang)
└── ~/mnt/server
```

After mounting, applications can read and write files in `~/mnt/server` exactly like a normal directory.

---

# Prerequisites

- Arch Linux on both machines
- SSH server running on the remote machine
- SSH access working
- SSHFS installed locally

---

# 1. Install SSHFS

On the local machine:

```bash
sudo pacman -S sshfs
```

Verify installation:

```bash
sshfs --version
```

---

# 2. SSH Configuration

SSH is configured with a named alias. The config lives at `~/.ssh/config`:

```text
Host hp-server
    HostName 192.168.1.3
    User sarang
    IdentityFile ~/.ssh/id_ed25519_hp-server
```

Test:

```bash
ssh hp-server
```

---

# 3. SSH Keys

Two keys are in use:

- **Local machine → server:** `~/.ssh/id_ed25519_hp-server`
- **iPad (Termius) → server:** Termius-generated key added to `~/.ssh/authorized_keys` on the server

The server's Tailscale IP is `100.100.208.10` — used for iPad access via Termius.

To add a new key to the server:

```bash
echo "ssh-ed25519 AAAA..." >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---

# 4. Create a Mount Point

```bash
mkdir -p ~/mnt/server
```

---

# 5. Mount and Unmount (Aliases)

Aliases are defined in `~/.bashrc` or `~/.zshrc`:

```bash
alias mount-server='sshfs hp-server:/home/sarang ~/mnt/server'
alias umount-server='fusermount -u ~/mnt/server'
```

Reload shell config:

```bash
source ~/.bashrc  # or ~/.zshrc
```

Mount:

```bash
mount-server
```

Unmount:

```bash
umount-server
```

---

# 6. Mount with Reconnection Options

For better reliability:

```bash
sshfs hp-server:/home/sarang ~/mnt/server \
    -o reconnect \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3
```

Update the alias to include these:

```bash
alias mount-server='sshfs hp-server:/home/sarang ~/mnt/server -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3'
```

---

# 7. Verify Mount

```bash
ls ~/mnt/server
findmnt ~/mnt/server
```

---

# 8. Tailscale

Tailscale is used for remote access (e.g. from iPad).

Check status:

```bash
tailscale status
```

Bring up Tailscale:

```bash
sudo tailscale up
```

Reset and re-authenticate:

```bash
sudo tailscale up --reset
```

Server Tailscale IP:

```bash
tailscale ip
```

---

# 9. Troubleshooting

## SSH Connection Fails

```bash
ssh hp-server
sudo systemctl status sshd
sudo systemctl enable --now sshd
```

## Permission Denied

Verify your public key is in `~/.ssh/authorized_keys` on the server. Check the key name — SSH only tries default names (`id_ed25519`, `id_rsa` etc.) unless `-i` or `IdentityFile` is specified.

## Stale Mount

```bash
fusermount -u ~/mnt/server
mount-server
```

## Wrong Username

The username is your account name (`sarang`), not the hostname (`sarang-hp`).

---

# Useful Commands

| Action | Command |
|---|---|
| Mount server | `mount-server` |
| Unmount server | `umount-server` |
| Check mount | `findmnt ~/mnt/server` |
| SSH into server | `ssh hp-server` |
| Tailscale status | `tailscale status` |
| Tailscale IP | `tailscale ip` |
