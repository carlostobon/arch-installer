#!/bin/sh

# Begins installing things
echo "Proceeding to install original repo packages.."
pacman -Syu --noconfirm
pacman_pkgs="./pacman.arch"

pacman_content=$(<"$pacman_pkgs")
pacman -Sy --noconfirm $pacman_content
