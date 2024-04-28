#!/bin/sh

# Begins installing things
echo "Proceeding to install original repo packages.."
pacstrap -K /mnt $(cat pacman.arch)
