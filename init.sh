#!/bin/env sh

# Begins installing things
echo "Proceeding to install original repo packages.."
pacstrap -K /mnt $(cat pacman.arch)
genfstab -U /mnt > /mnt/etc/fstab
cp runner.sh /mnt
arch-chroot /mnt
