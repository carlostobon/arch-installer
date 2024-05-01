#!/bin/sh

echo "setting local time..."
ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime

echo "setting clock..."
hwclock --systohc

echo "generating locals..."
sed -i 's/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/' > /etc/locale.gen
sed -i 's/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/' > /etc/locale.gen

locale-gen

echo "setting language and keyboard..."
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=colemak-dh > /etc/vconsole.conf
cp -r ./colemak-dh /usr/share/kbd/keymaps/i386/

read -p "Enter a hostname: " hname
echo "$hname" > "/etc/hostname"

echo "setting grub..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Password for root: "
passwd

echo "creating user..."
read -p "Enter your username: " username
useradd -m -g users -G wheel -s /bin/bash "$username"
echo "Password for $username"
passwd "$username"

echo "setting network manager..."
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

echo "cloning dotfiles..."
git clone "https://github.com/carlostobon/dotfiles" "~/$username/.dotfiles"
mkdir "~/$username/.binaries" "~/$username/.config/wallpaper" "/usr/share/fonts/ttf"

echo "copying fonts..."
cp "fonts/comic_mono.ttf" "/usr/share/fonts/ttf"
cp "fonts/comic_mono_bold.ttf" "/usr/share/fonts/ttf"
echo "exec xmonad" > "~/$username/.xinitrc"

echo "Installation done! Once logged in proceed
      to compile Xmonad and run the script in dotfiles."
