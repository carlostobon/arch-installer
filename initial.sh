#!/bin/env sh

echo "Proceeding to install Pacman managed packages..."

# Install all packages in file pacman.arch
pacstrap -K /mnt "$(cat core.arch)"

# Generates UUIDS for booting and system handling.
genfstab -U /mnt > /mnt/etc/fstab

# Copy files into installation
cp aur.arch /mnt
cp -r colemak-dh /mnt
cp -r fonts /mnt
cp secondary.sh /mnt

# Jump into installation
arch-chroot /mnt
