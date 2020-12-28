#!/usr/bin/env bash

print_ok() {
    printf "\e[32m%b\e[0m" "$1""\n"
}

print_info() {
    printf "\e[36m%b\e[0m" "$1""\n"
}
# Exit if some error occurs
set -e 

# Install zsh
# base-devel needed for fakeroot installation of yay
# go needed as yay dependency
pacman -Sy --noconfirm zsh sudo base-devel go

# User and home creation. Default shell change to zsh
print_info "Insert new user: "
read -r username
useradd -m -s /usr/bin/zsh $username
passwd $username
usermod -aG wheel $username
print_ok "User and home created. Default shell set to zsh"

# Wheel group modification
print_info "Changing wheel permission"
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
print_ok "done"

# Set /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/locatime
print_ok "localtime linked"

# TODO: test this
locale-gen en_us.UTF-8

# Changing user
echo "Now write 'su - $username' to log in and run post-setup-2.sh"
