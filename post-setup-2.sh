#!/usr/bin/env bash

print_ok() {
    printf "\e[32m%b\e[0m" "$1""\n"
}

print_info() {
    printf "\e[36m%b\e[0m" "$1""\n"
}
# Exit if some error occurs
set -e

# Clone config repository creates a bare repository with all files unstaged
#sudo rm -rf $HOME/projects/dotfiles
git clone --bare https://github.com/MarcoDiFrancesco/dotfiles $HOME/projects/dotfiles
# Hard reset is used to make reappear the files
git --git-dir=$HOME/projects/dotfiles --work-tree=$HOME reset --hard
# To not show all unstaged files in home directory
git --git-dir=$HOME/projects/dotfiles --work-tree=$HOME config status.showUntrackedFiles no

# Installing yay
print_info "Installing yay"
cd /tmp
#sudo rm -rf yay # Used for testing
git clone https://aur.archlinux.org/yay.git
cd yay
print_info "Yay cloned"
makepkg -si --noconfirm
print_ok "done"

# Install all pacman packages (pacman -Qqen)
yay -Sy --noconfirm $(cat 8ef8e5e39f34ca3b0ec616012fd7df2b/packages-pacman.list)
# Install all AUR packages (pacman -Qqm) 
yay -Sy --noconfirm $(cat 8ef8e5e39f34ca3b0ec616012fd7df2b/packages-aur.list)

# Set timezone
timedatectl set-timezone Europe/Rome

# enable services
print_info "Enabling some services"
sudo systemctl enable bluetooth.service
sudo systemctl enable bumblebeed.service
sudo systemctl enable cronie.service
sudo systemctl enable docker.service
print_ok "done"

source ~/.zshrc
source ~/.zshenv
print_ok "zshrc and zshenv sourced"
