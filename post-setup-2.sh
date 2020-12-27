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
yay -Sy --noconfirm $(cat /tmp/arch-installer/packages-pacman.list)
# Install all AUR packages (pacman -Qqm) 
yay -Sy --noconfirm $(cat /tmp/arch-installer/packages-aur.list)

# enable services
print_info "Enabling some services"
sudo systemctl enable bluetooth.service
sudo systemctl enable bumblebeed.service
sudo systemctl enable cronie.service
sudo systemctl enable docker.service
sudo systemctl enable NetworkManager.service
print_ok "done"

source ~/.zshenv
source ~/.config/zsh/.zshrc
print_ok "zshrc and zshenv sourced"

# TODO: install oh-my-zsh-git and all other AUR packages (yay -Qmq)
