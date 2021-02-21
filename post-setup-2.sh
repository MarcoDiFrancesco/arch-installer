#!/usr/bin/env bash

print_ok() {
    printf "\e[32m%b\e[0m" "$1""\n"
}

print_info() {
    printf "\e[36m%b\e[0m" "$1""\n"
}
# Exit if some error occurs
set -e

DOTFILESDIR=$HOME/projects/dotfiles
if [ ! -d $DOTFILESDIR ]; then
    print_info "Cloning dotfiles directory"
    # Clone config repository creates a bare repository with all files unstaged
    git clone --bare https://github.com/MarcoDiFrancesco/dotfiles $DOTFILESDIR
    # Hard reset is used to make reappear the files
    git --git-dir=$DOTFILESDIR --work-tree=$HOME reset --hard
    # To not show all unstaged files in home directory
    git --git-dir=$DOTFILESDIR --work-tree=$HOME config status.showUntrackedFiles no
    print_ok "Dotfiles directory cloned"
fi

YAYDIR=/tmp/yay
if [ ! -d $YAYDIR ]; then
    # Installing yay
    print_info "Installing yay"
    git clone https://aur.archlinux.org/yay.git $YAYDIR
    print_info "Yay cloned"
    cd $YAYDIR
    makepkg -si --noconfirm
    print_ok "Yay installed"
fi

# Install all pacman packages (pacman -Qqen)
yay -Sy --needed --noconfirm $(cat /tmp/arch-installer/packages-pacman.list)
# Install all AUR packages (pacman -Qqm) 
yay -Sy --needed --noconfirm $(cat /tmp/arch-installer/packages-aur.list)

# Install code stats zsh plugin
CODESTATSDIR="/usr/share/oh-my-zsh/custom/plugins/"
if [ ! -d $DOTFILESDIR ]; then
    sudo git clone https://gitlab.com/code-stats/code-stats-zsh $CODESTATSDIR
fi
# enable services
print_info "Enabling some services"
sudo systemctl enable bluetooth.service
sudo systemctl enable bumblebeed.service
sudo systemctl enable cronie.service
sudo systemctl enable docker.service
sudo systemctl enable NetworkManager.service
print_ok "Done, reboot the system"
