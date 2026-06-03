# SSHFS Setup Guide (Arch Linux ↔ Arch Linux)

This guide explains how to mount a directory from a remote Arch Linux server as a local folder using SSHFS and manage the mount with systemd.

---

# Overview

SSHFS (SSH Filesystem) allows you to access files on a remote machine as if they were stored locally.

Example:

```text
Remote Server (hp-server)
└── /home/sarang

Local Machine
└── ~/mnt/hp-server
```

After mounting, applications can read and write files in `~/mnt/hp-server` exactly like a normal directory.

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

# 2. Configure SSH Access

Verify that SSH works:

```bash
ssh hp-server
```

If SSH is not yet configured, create an SSH config entry:

```text
# ~/.ssh/config

Host hp-server
    HostName 192.168.1.100
    User sarang
    IdentityFile ~/.ssh/id_ed25519
```

Test:

```bash
ssh hp-server
```

You should be able to log in successfully.

---

# 3. Configure SSH Keys (Recommended)

Generate a key pair if necessary:

```bash
ssh-keygen -t ed25519
```

Copy the public key to the server:

```bash
ssh-copy-id hp-server
```

Verify passwordless login:

```bash
ssh hp-server
```

---

# 4. Create a Mount Point

Create a local directory that will contain the remote files:

```bash
mkdir -p ~/mnt/hp-server
```

---

# 5. Mount the Remote Directory Manually

Mount your remote home directory:

```bash
sshfs hp-server:/home/sarang ~/mnt/hp-server
```

Verify:

```bash
ls ~/mnt/hp-server
```

You should see files from the server.

---

# 6. Use the Mounted Directory

Examples:

```bash
cd ~/mnt/hp-server
```

```bash
cp local-file.txt ~/mnt/hp-server/
```

```bash
nano ~/mnt/hp-server/config.yaml
```

Any editor or file manager should work normally.

---

# 7. Automatic Reconnection

For better reliability:

```bash
sshfs hp-server:/home/sarang ~/mnt/hp-server \
    -o reconnect \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3
```

These options:

- reconnect automatically after a disconnect
- send keepalive packets every 15 seconds
- detect dead connections after roughly 45 seconds

---

# 8. Unmount the Filesystem

Unmount manually:

```bash
fusermount3 -u ~/mnt/hp-server
```

Alternative:

```bash
umount ~/mnt/hp-server
```

---

# 9. Configure Automatic Mounting with systemd

## Important

For `.mount` units:

> The filename must match the path specified in `Where=`.

This is a common source of errors.

For example:

```text
Where=/home/sarang/mnt/hp-server
```

cannot be stored in:

```text
server.mount
```

because systemd will reject it.

---

## Determine the Correct Unit Name

Generate the required name:

```bash
systemd-escape --path --suffix=mount /home/sarang/mnt/hp-server
```

Example output:

```text
home-sarang-mnt-hp\x2dserver.mount
```

This is the filename you must use.

---

## Create the Mount Unit

Create:

```text
~/.config/systemd/user/home-sarang-mnt-hp\x2dserver.mount
```

Contents:

```ini
[Unit]
Description=SSHFS Mount for hp-server
After=network-online.target
Wants=network-online.target

[Mount]
What=hp-server:/home/sarang
Where=/home/sarang/mnt/hp-server
Type=fuse.sshfs
Options=reconnect,_netdev

[Install]
WantedBy=default.target
```

---

## Reload systemd

```bash
systemctl --user daemon-reload
```

---

## Enable and Start

```bash
systemctl --user enable --now home-sarang-mnt-hp\\x2dserver.mount
```

---

## Verify

Check status:

```bash
systemctl --user status home-sarang-mnt-hp\\x2dserver.mount
```

Verify the filesystem:

```bash
findmnt ~/mnt/hp-server
```

or

```bash
mount | grep hp-server
```

---

## Manual Control

Mount:

```bash
systemctl --user start home-sarang-mnt-hp\\x2dserver.mount
```

Unmount:

```bash
systemctl --user stop home-sarang-mnt-hp\\x2dserver.mount
```

Disable automatic mounting:

```bash
systemctl --user disable home-sarang-mnt-hp\\x2dserver.mount
```

---

# 10. Troubleshooting

## SSH Connection Fails

Verify:

```bash
ssh hp-server
```

Check SSH daemon on the server:

```bash
sudo systemctl status sshd
```

Enable it:

```bash
sudo systemctl enable --now sshd
```

---

## Permission Denied

Check:

```bash
ssh hp-server
```

Verify your public key exists on the server:

```text
~/.ssh/authorized_keys
```

---

## Mount Appears Empty

Verify the remote path:

```bash
ssh hp-server
ls /home/sarang
```

Confirm that the mounted directory contains files.

---

## Stale Mount

Unmount and remount:

```bash
fusermount3 -u ~/mnt/hp-server
```

```bash
systemctl --user restart home-sarang-mnt-hp\\x2dserver.mount
```

---

## "Where= setting doesn't match unit name"

Cause:

```text
Where=/home/sarang/mnt/hp-server
```

but the file is named:

```text
server.mount
```

Solution:

Generate the correct filename:

```bash
systemd-escape --path --suffix=mount /home/sarang/mnt/hp-server
```

Rename the unit accordingly.

---

# Useful Commands

Mount manually:

```bash
sshfs hp-server:/home/sarang ~/mnt/hp-server
```

Unmount:

```bash
fusermount3 -u ~/mnt/hp-server
```

Check mount:

```bash
findmnt ~/mnt/hp-server
```

Check systemd status:

```bash
systemctl --user status home-sarang-mnt-hp\\x2dserver.mount
```

Reload user units:

```bash
systemctl --user daemon-reload
```

Enable automatic mounting:

```bash
systemctl --user enable --now home-sarang-mnt-hp\\x2dserver.mount
```
