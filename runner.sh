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

read -p "Enter a HOSTNAME: " hname
echo "$hname" > "/etc/hostname"

echo "setting grub..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Password for ROOT: "
passwd

echo "creating user..."
read -p "Enter your USERNAME: " username
useradd -m -g users -G wheel -s /bin/bash "$username"
echo "Password for $username"
passwd "$username"

echo "setting network manager..."
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

mkdir -p "/usr/share/fonts/ttf" \
         "/home/$username/.local/bin" \
         "/home/$username/.binaries"

echo "copying fonts..."
cp "fonts/comic_mono.ttf" "/usr/share/fonts/ttf"
cp "fonts/comic_mono_bold.ttf" "/usr/share/fonts/ttf"

echo "cloning dotfiles..."
git clone "https://github.com/carlostobon/dotfiles" "/home/$username/.dotfiles"

echo "setting dotfiles..."
su - $username -c "cd /home/$username/.dotfiles && ./run.sh"
chown -R ${username} /home/$username/.dotfiles

echo "setting xmonad xorg server..."
echo "exec xmonad" > "/home/$username/.xinitrc"


echo "placing xmonad..."
(cd /home/$username/.xmonad && \
      git clone https://github.com/xmonad/xmonad && \
      git clone https://github.com/xmonad/xmonad-contrib && \
      stack upgrade)

echo "compiling xmonad..."
chown -R ${username} /home/$username/.xmonad
su - $username -c "(cd /home/$username/.xmonad && stack init && stack install)"


echo "Installation done! Once logged in proceed
      to compile Xmonad and run the script in dotfiles."
