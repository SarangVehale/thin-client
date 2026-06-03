# SSHFS Setup Guide (Arch Linux → Arch Linux)

This guide explains how to mount a directory from a remote Arch Linux server as a local folder using SSHFS.

---

## Prerequisites

* Arch Linux on both machines
* SSH server running on the remote machine
* Network connectivity between the machines
* User account on the remote machine

Verify SSH access first:

```bash
ssh user@server
```

If this does not work, fix SSH connectivity before proceeding.

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

# 2. Configure SSH Key Authentication (Recommended)

Generate a key pair if you do not already have one:

```bash
ssh-keygen -t ed25519
```

Copy the public key to the server:

```bash
ssh-copy-id user@server
```

Test login:

```bash
ssh user@server
```

You should be able to log in without entering a password.

---

# 3. Create a Mount Point

Choose a local directory where the remote files will appear:

```bash
mkdir -p ~/mnt/server
```

---

# 4. Mount the Remote Directory

Mount the remote home directory:

```bash
sshfs user@server:/home/user ~/mnt/server
```

Example:

```bash
sshfs alice@192.168.1.100:/home/alice ~/mnt/server
```

Verify:

```bash
ls ~/mnt/server
```

You should see files from the remote machine.

---

# 5. Use SSH Config Aliases (Optional)

Create or edit:

```bash
~/.ssh/config
```

Example:

```text
Host homeserver
    HostName 192.168.1.100
    User alice
    IdentityFile ~/.ssh/id_ed25519
```

Test:

```bash
ssh homeserver
```

Mount using the alias:

```bash
sshfs homeserver:/home/alice ~/mnt/server
```

---

# 6. Enable Automatic Reconnection

For more reliable mounts:

```bash
sshfs homeserver:/home/alice ~/mnt/server \
    -o reconnect \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3
```

These options help recover from temporary network interruptions.

---

# 7. Unmount the Filesystem

Unmount when finished:

```bash
fusermount3 -u ~/mnt/server
```

Alternative:

```bash
umount ~/mnt/server
```

---

# 8. Mount a Specific Directory

Instead of mounting an entire home directory:

```bash
sshfs homeserver:/srv/projects ~/mnt/server
```

Only the `/srv/projects` directory will be visible locally.

---

# 9. Mount Automatically with systemd

Create:

```bash
mkdir -p ~/.config/systemd/user
```

Create:

```bash
~/.config/systemd/user/server.mount
```

Contents:

```ini
[Unit]
Description=SSHFS Server Mount

[Mount]
What=alice@192.168.1.100:/home/alice
Where=%h/mnt/server
Type=fuse.sshfs
Options=reconnect,IdentityFile=%h/.ssh/id_ed25519,_netdev

[Install]
WantedBy=default.target
```

Reload systemd:

```bash
systemctl --user daemon-reload
```

Enable and start the mount:

```bash
systemctl --user enable --now server.mount
```

Check status:

```bash
systemctl --user status server.mount
```

---

# Troubleshooting

### Connection Refused

Verify the SSH server is running:

```bash
systemctl status sshd
```

Start it if necessary:

```bash
sudo systemctl enable --now sshd
```

### Permission Denied

Check SSH authentication:

```bash
ssh user@server
```

Verify your public key exists in:

```text
~/.ssh/authorized_keys
```

### Mount Appears Empty

Confirm the remote path exists:

```bash
ssh user@server
ls /home/user
```

### Stale Mount

Unmount and remount:

```bash
fusermount3 -u ~/mnt/server
```

```bash
sshfs user@server:/home/user ~/mnt/server
```

---

# Useful Examples

Mount remote home:

```bash
sshfs user@server:/home/user ~/mnt/server
```

Mount remote projects directory:

```bash
sshfs user@server:/srv/projects ~/mnt/projects
```

Mount using SSH alias:

```bash
sshfs homeserver:/home/alice ~/mnt/server
```

Unmount:

```bash
fusermount3 -u ~/mnt/server
```

