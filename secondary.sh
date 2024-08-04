#!/bin/sh

# This script requires error handling
# and setting sudoers configuration
# lot of things can go wrong.

echo "Setting local time..."
ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime

if [ ! "$DOCKER_ACTIVE" = "true" ]; then
      echo "setting clock..."
      hwclock --systohc
fi

echo "Generating locals..."
sed -i 's/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/' > /etc/locale.gen
sed -i 's/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/' > /etc/locale.gen

locale-gen

echo "Setting language and keyboard..."
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=colemak-dh > /etc/vconsole.conf
cp -r ./colemak-dh /usr/share/kbd/keymaps/i386/

read -p "Set a hostname: " hname
echo "$hname" > "/etc/hostname"

if [ ! "$DOCKER_ACTIVE" = "true" ]; then
      echo "setting grub..."
      grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
      grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Set root pasword"
passwd

echo "Creating user..."
read -p "Set your username: " username
useradd -m -g users -G wheel -s /bin/bash "$username"
echo "Set $username password"
passwd "$username"

if [ ! "$DOCKER_ACTIVE" = "true" ]; then
      echo "Setting network manager..."
      systemctl enable NetworkManager.service
      systemctl start NetworkManager.service
fi

mkdir -p "/usr/share/fonts/ttf" \

echo "Copying fonts..."
cp fonts/* /usr/share/fonts/ttf/

echo "Creating needed directories..."
su - $username -c "mkdir -p /home/$username/.local/bin $HOME/.binaries"

echo "Cloning dotfiles from github..."
su - $username -c "git clone https://github.com/carlostobon/dotfiles /home/$username/.dotfiles"

echo "Setting dotfiles links..."
su - $username -c "cd /home/$username/.dotfiles && ./run.sh"

echo "Setting xmonad xorg server..."
su - $username -c "sh -c 'echo exec xmonad > /home/$username/.xinitrc'"


echo "Placing xmonad files..."
cd /home/$username/.xmonad && \
       git clone https://github.com/xmonad/xmonad && \
       git clone https://github.com/xmonad/xmonad-contrib && \
       stack upgrade

echo "Compiling xmonad..."
chown -R root /home/$username/.xmonad
cd /home/$username/.xmonad && stack update && stack init && stack install
mv /root/.local/bin/xmonad /home/$username/.local/bin/
chown -R ${username} /home/$username/.xmonad

echo "Insallation done, set sudoers and re-compile xmonad if needed."
