#!/bin/sh

# Begins installing things
echo "Proceeding to install original repo packages.."
pacstrap -K /mnt $(cat pacman.arch)
genfstab -U /mnt > /mnt/etc/fstab
arch-chroot /mnt
