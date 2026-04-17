#!/bin/bash

set -e

echo "=> Installing packages..."
sudo pacman -S --noconfirm openssh git tmux neovim yazi tailscale

echo "=> Enabling services..."
sudo systemctl enable --now sshd
sudo systemctl enable --now tailscaled

echo "=> Starting tailscale..."
sudo tailscale up

echo "=> Setting up directories"
mkdir -p ~/transfer
mkdir -p ~/repos

echo "=> Linking dotfiles"

ln -sf ~/setup/dotfiles/bashrc ~/.bashrc
ln -sf ~/setup/dotfiles/tmux.conf ~/.tmux.conf

mkdir -p ~/.config
ln -sf ~/setup/dotfiles/nvim ~/.config/nvim

echo "=> Done. Restart shell or run: source ~/.bashrc"
