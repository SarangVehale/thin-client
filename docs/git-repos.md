# Git Bare Repos

The server acts as a private Git remote for syncing code between devices without using GitHub.

---

## Create a Bare Repo on the Server

```bash
mkdir -p ~/repos/<project>.git
cd ~/repos/<project>.git
git init --bare
```

---

## Use It from Another Machine

Add as a remote:
```bash
git remote add origin sarang@hp-server:~/repos/<project>.git
```

Or if cloning fresh:
```bash
git clone sarang@hp-server:~/repos/<project>.git
```

Push and pull normally:
```bash
git push origin main
git pull origin main
```

---

## Design Rules

- **No SSHFS on sensitive machines** — use Git as the only bridge
- **Server cannot push to other machines** — one-way pull only
- Each device is independent; no implicit trust

---

## List Existing Repos

```bash
ls ~/repos/
```

---

## Remove a Repo

```bash
rm -rf ~/repos/<project>.git
```
