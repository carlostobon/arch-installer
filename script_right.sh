#!/bin/sh

echo "Stablishing network connection..."
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

echo "Creating user..."
read -p "Enter your username: " username
useradd -m -g users -G wheel -s /bin/bash $username
passwd $username
