# Recovery Checklist

Exact commands to restore the server after a wipe. No explanation — just run these in order.

---

## 1. Clone setup repo

```bash
git clone https://github.com/sarang-kernel/thin-client.git ~/setup
```

## 2. Run bootstrap

```bash
~/setup/setup/bootstrap.sh
```

## 3. Add SSH keys

```bash
nvim ~/.ssh/authorized_keys
```

Paste keys for: local machine, iPad (Termius). See [ssh-keys.md](ssh-keys.md) for the full list.

## 4. Connect Tailscale

```bash
sudo tailscale up
```

## 5. Verify SSH access

From local machine:
```bash
ssh -i ~/.ssh/id_ed25519_hp-server sarang@192.168.1.3
```

## 6. Recreate Git bare repos (if needed)

```bash
mkdir -p ~/repos/<project>.git
cd ~/repos/<project>.git
git init --bare
```

Then re-add remotes on other machines:
```bash
git remote set-url origin sarang@hp-server:~/repos/<project>.git
```

## 7. Reload shell

```bash
source ~/.bashrc
```

---

Done. Everything else (nvim config, tmux config) is handled by bootstrap automatically.
