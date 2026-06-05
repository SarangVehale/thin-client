#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=> Installing packages..."
sudo pacman -S --noconfirm openssh git tmux neovim yazi sshfs tailscale

echo "=> Enabling services..."
sudo systemctl enable --now sshd
sudo systemctl enable --now tailscaled

echo "=> Hardening SSH..."
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "=> Setting up directories..."
mkdir -p ~/transfer
mkdir -p ~/repos
mkdir -p ~/mnt/server
mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "=> Linking dotfiles..."
ln -sf "$SCRIPT_DIR/dotfiles/bashrc" ~/.bashrc
ln -sf "$SCRIPT_DIR/dotfiles/tmux.conf" ~/.tmux.conf

echo "=> Cloning nvim config..."
if [ -d ~/.config/nvim ]; then
    echo "   ~/.config/nvim already exists, skipping."
else
    git clone https://github.com/sarang-kernel/nvim.git ~/.config/nvim
fi

echo ""
echo "=> Done. Manual steps remaining:"
echo "   1. Add SSH public keys to ~/.ssh/authorized_keys"
echo "   2. Run: sudo tailscale up"
echo "   3. Reload shell: source ~/.bashrc"
