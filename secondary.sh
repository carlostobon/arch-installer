#!/bin/sh

# This script performs a basic installation of Arch Linux
# and sets up the system after switching to the new root environment.
# It also compiles Xmonad, configures Colemak-DH as the keyboard layout,
# and installs the Comic font.

# This script should not be run if the packages listed in pacman.arch
# are not already installed in the new system.

set -e

echo "Setting local time..."
ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime

echo "Generating locals..."
sed -i 's/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/' > /etc/locale.gen
sed -i 's/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/' > /etc/locale.gen

locale-gen

echo "Setting language and keyboard..."
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=colemak-dh > /etc/vconsole.conf
cp -r ./colemak-dh /usr/share/kbd/keymaps/i386/

echo "Introduce your hostname: "
read -r hname
echo "Hostname set to: $hname"
echo "$hname" > "/etc/hostname"

echo "Set a password for root: "
passwd

echo "Creating user..."
echo "Introduce your username: "
read -r username

useradd -m -g users -G wheel -s /bin/bash "$username"

echo "Set a password for $username: "
passwd "$username"

mkdir -p "/usr/share/fonts/ttf" \

echo "Copying fonts..."
cp fonts/* /usr/share/fonts/ttf/


su - "$username" << 'EOF'

echo "Creating needed directories..."
mkdir -p "$HOME/.local/bin" "$HOME/.binaries"

echo "Cloning dotfiles from github..."
git clone https://github.com/carlostobon/dotfiles "$HOME/.dotfiles"

echo "Setting dotfiles links..."
cd "$HOME/.dotfiles" && ./run.sh

echo "Setting Xmonad xorg server..."
echo exec xmonad > "$HOME/.xinitrc"

echo "Setting Xmonad..."
echo "Creating directory for Xmonad..."
mkdir -p "$HOME/.config/xmonad"

echo "Cloning repos..."
cd "$HOME/.config/xmonad" && \
      git clone https://github.com/xmonad/xmonad && \
      git clone https://github.com/xmonad/xmonad-contrib

echo "Initiating Stack project..."
# The first time init is run, it creates a global configuration
# file at $HOME/.stack/config.yaml
cd "$HOME/.config/xmonad" && stack init

# Configures global snapshot settings for the stack tool.
echo "urls:" >> "$HOME/.stack/config.yaml"
echo "  latest-snapshot: https://stackage-haddock.haskell.org/snapshots.json" >> "$HOME/.stack/config.yaml"

echo "Compiling xmonad..."
cd "$HOME/.config/xmonad" && stack init && stack install

echo "Installation done, now set sudoers in /etc/sudoers."
EOF
