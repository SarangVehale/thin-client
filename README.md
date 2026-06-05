# thin-client

Reproducible setup for an Arch Linux remote dev server, accessible from any device via SSH + Tailscale.

## Quick Start

```bash
git clone https://github.com/sarang-kernel/thin-client.git ~/setup
~/setup/setup/bootstrap.sh
```

After bootstrap, complete the [manual steps](setup/README.md).

## Architecture

```
iPad (Termius)
└── SSH → tmux → nvim + yazi

Local Machine
├── SSH → server
└── SSHFS → ~/mnt/server

Server (sarang-hp / Arch Linux)
├── OpenSSH
├── Tailscale
├── Git bare repos
└── Dev environment (nvim, tmux, yazi)
```

## Docs

- [Setup guide](setup/README.md) — post-bootstrap manual steps
- [SSH keys](docs/ssh-keys.md) — key inventory, adding devices, troubleshooting
- [Tailscale](docs/tailscale.md) — setup, device management, troubleshooting
- [SSHFS](docs/sshfs-setup.md) — mounting server filesystem on local machine
- [Git repos](docs/git-repos.md) — using server as a private Git remote
- [Recovery](docs/recovery.md) — exact commands to restore after a wipe
