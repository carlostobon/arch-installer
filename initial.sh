#!/bin/env sh

echo "Proceeding to install pacman managed packages..."
# Install all pkgs in file pacman.ard
pacstrap -K /mnt $(cat pacman.arch)

# Generates uuids for booting and
# system handling.
genfstab -U /mnt > /mnt/etc/fstab

# Copy files into tinstallation
cp aurh.arch /mnt
cp -r colemak-dh /mnt
cp -r fonts /mnt
cp secondary.sh /mnt

# Jump into installation
arch-chroot /mnt
