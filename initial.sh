#!/bin/env sh

echo "Proceeding to install Pacman managed packages..."

# Install all pkgs in file pacman.ard
pacstrap -K /mnt "$(cat pacman.arch)"

# Generates UUIDS for booting and
# system handling.
genfstab -U /mnt > /mnt/etc/fstab

# Copy files into installation
cp aurh.arch /mnt
cp -r colemak-dh /mnt
cp -r fonts /mnt
cp secondary.sh /mnt

# Jump into installation
arch-chroot /mnt
