🖥️ Personal Remote Dev Environment (Arch + iPad)

Reproducible Setup Document

⸻

🔷 1. OVERVIEW

This setup turns your Arch Linux laptop into a private remote development server, accessible securely from your iPad and other devices.

Core Principles

- Terminal-first workflow (no GUI dependency)
- Zero-trust between machines
- Minimal, reproducible, and maintainable
- No cloud dependency

⸻

🔷 2. FINAL ARCHITECTURE

iPad (Termius)
├── SSH → tmux → nvim + yazi
└── SFTP → file transfer
Other Laptop
└── Git pull/push
Server (Arch Linux)
├── SSH server
├── Tailscale node
├── Git remote (bare repos)
└── Development environment

⸻

🔷 3. CORE COMPONENTS

- OpenSSH → remote access + SFTP
- Tailscale → secure networking
- Termius → iPad terminal + file access
- Git → controlled file synchronization

⸻

🔷 4. BASE SYSTEM SETUP (ARCH)

Install essentials

sudo pacman -S openssh git tmux neovim yazi tailscale

⸻

Enable SSH

sudo systemctl enable --now sshd

⸻

Enable Tailscale

sudo systemctl enable --now tailscaled
sudo tailscale up

⸻

🔷 5. SSH HARDENING (IMPORTANT)

Edit:

sudo nvim /etc/ssh/sshd_config

Set:

PasswordAuthentication no
PermitRootLogin no

Restart:

sudo systemctl restart sshd

⸻

Add SSH key

From iPad (Termius), copy public key and add:

nvim ~/.ssh/authorized_keys

⸻

🔷 6. TERMius SETUP (iPad)

Add host:

user@<tailscale-ip>

Features used:

- SSH terminal
- SFTP file browser

⸻

🔷 7. FILE TRANSFER SETUP

Create transfer directory

mkdir -p ~/transfer

Use this for:

- temporary file exchange
- uploads/downloads via SFTP

⸻

🔷 8. TERMINAL ENVIRONMENT

tmux config

nvim ~/.tmux.conf
set -g mouse on
set-option -g set-clipboard off

Reload:

tmux source-file ~/.tmux.conf

⸻

shell config

nvim ~/.bashrc

Add:

export TERM=xterm-256color

⸻

🔷 9. NEOVIM BASIC CONFIG

nvim ~/.config/nvim/init.lua
vim.opt.clipboard = "unnamedplus"

⸻

🔷 10. DAILY WORKFLOW

Connect

- Open Termius
- SSH into server

⸻

Work

tmux
nvim
yazi

⸻

File transfer

- Use Termius SFTP tab
- Upload/download via ~/transfer

⸻

🔷 11. MULTI-DEVICE FILE STRATEGY

❗ Important Design Decision

Laptop B (sensitive machine):

- ❌ NO direct filesystem sharing
- ❌ NO SSHFS
- ❌ NO mounting via server

⸻

✔ Use Git as the ONLY bridge

On server (create repo)

mkdir -p ~/repos/project.git
cd ~/repos/project.git
git init --bare

⸻

On Laptop B

git remote add origin user@server:~/repos/project.git
git push origin main

⸻

On other devices

git clone user@server:~/repos/project.git

⸻

🔷 12. ZERO TRUST MODEL

Rules:

- Each device is independent
- No implicit trust between machines
- Server CANNOT access Laptop B
- Only explicit SSH connections allowed

⸻

Network model (via Tailscale)

iPad → Server (allowed)
iPad → Laptop B (allowed)
Server → Laptop B (blocked)

⸻

🔷 13. SECURITY RULES

DO:

- Use SSH keys only
- Keep Laptop B isolated
- Use Git for sensitive data transfer
- Use Tailscale for all connections

⸻

DO NOT:

- Use SSHFS on sensitive machines
- Expose filesystems across devices
- Enable password authentication
- Use agent forwarding (ssh -A)

⸻

🔷 14. RECOVERY CHECKLIST (AFTER RESET)

If system is wiped, redo:

1. Install packages

pacman -S openssh git tmux neovim yazi tailscale

2. Enable services

systemctl enable --now sshd
systemctl enable --now tailscaled
tailscale up

3. Add SSH keys

nvim ~/.ssh/authorized_keys

4. Setup configs

- .bashrc
- .tmux.conf
- nvim config

5. Recreate Git repos

git init --bare

⸻

🔷 15. FINAL STATE

You now have:

✔ Remote dev environment
✔ Secure private network
✔ File transfer via SFTP
✔ Multi-device workflow via Git
✔ Zero-trust architecture

⸻

🔷 16. DESIGN PHILOSOPHY (IMPORTANT)

This system is built around:

Minimalism > Convenience
Security > Accessibility
Explicit actions > Implicit access

⸻
