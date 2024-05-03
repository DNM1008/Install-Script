#!/bin/sh
#
user=$(whoami)
wd=$(pwd)

echo "Enabling parallel downloads"

sudo sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf

echo "Initial sync"


sudo pacman -S --noconfirm base-devel

echo "Installing yay"

mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm

# Updating
yay

echo "Installing software"

#Placeholder#
#yay -S  fastfetch antidot acpi pcmanfm alacritty pulseaudio pavucontrol alsa-utils catppuccin-gtk-theme-macchiato cmake cmatrix ffmpeg ffmpegthumbnailer firefox mailspring neovim qtile qtile-extras rofi xorg xwallpaper xorg-xrdb xss-lock i3lock udiskie zathura-git zathura-cb-git zathura-djvu-git zathura-pdf-mupdf-git zathura-ps-git python-psutil python-pulsectl-asyncio starship fortune-mod gtk2 ly cups system-config-printer bluez bluez-utils bluetuith python-pip evremap --noconfirm
yay -S --noconfirm - < $wd/packages.txt

echo "Installing fonts"

#yay -S adobe-sorce-code-pro-fonts nerd-fonts ttf-ms-fonts ttf-tahoma ttf-vista-fonts ttf-fira-mono ttf-linux-libertine ttf-inconsolata noto-fonts cantarell-fonts --noconfirm
yay -S --noconfirm - < $wd/fonts.txt

echo "Installing rofi theme"
cd ~/Downloads
git clone https://github.com/catppuccin/rofi.git && cd rofi/basic

echo "Installing rofi power menu"
mkdir ~/.local/bin/scripts/
cd $wd
cp rofi-power-menu ~/.local/bin/scripts/rofi-power-menu


echo "Installing da dots and sum system config"

git clone --depth=1 https://github.com/DNM1008/Dots && cd Dots

cp -r .config/* ~/.config/
# sudo echo "source /home/$user/.config/bash_profile" >> /etc/bash.bashrc
echo "source /home/$user/.config/bash/bash_profile" | sudo tee -a /etc/bash.bashrc
sudo cp ~/.config/gtk-2.0/gtkrc /etc/gtk-2.0/gtkrc
echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment

echo "Installing nvChad"

git clone https://github.com/NvChad/starter ~/.config/nvim 

echo "Enabling services"

# Enabling evremap
sudo cp ~/.config/evremap/evremap.toml /etc/evremap.toml
sudo cp /Install-Script/evremap.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable evremap

# Enabling the ly display manager
sudo systemctl enable ly
# Enabling CUPS
sudo systemctl enable cups
sudo usermod -aG lp $user
# Enabling Bluetooth
sudo systemctl enable bluetooth
echo "Cleaning up"
cd

source .config/bash/bash_profile

sudo rm -r .bash_history .bash_profile .bash_logout .bashrc
sudo rm -r .gnupg/
sudo rm -r go/
yay -Scc --noconfirm

sudo rm -r  ~/go
antidot update
antidot clean
eval "$(antidot init)"

echo "The basic setup should be done for now, to get your system to a more functional state, consider install pandoc and texlive, or if it's not what you're looking for, libre office. CUPS has been installed and enabled, however, you probably need to install the specific driver for your printer. To know what driver you need, consult the Arch Wiki. Bluetooth is installed and should be accessible through 'bluetoothctl' or 'bluetuith'. If you don't use my keymap, disable evremap or edit the config file at '/etc/evremap.toml'. Consult the Arch Wiki for more. Reboot now for changes to take effect."

read -p "Press any key to reboot"


# finishing up cleanup
#

sudo rm -r Install-Script/

reboot
