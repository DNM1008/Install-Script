#!/bin/sh
#
set -e
user=$(whoami)
wd=$(pwd)
echo "Removing password requirement for sudo commands"

echo "Making Pacman look prettier"
sudo grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

echo "Enabling parallel downloads"

sudo sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf

echo "Initial sync"


sudo pacman -Syyu 

echo "Installing yay"

mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si --noconfirm

# Updating
yay

echo "Installing software"

#Placeholder#
#yay -S  fastfetch antidot acpi pcmanfm alacritty pulseaudio pavucontrol alsa-utils catppuccin-gtk-theme-macchiato cmake cmatrix ffmpeg ffmpegthumbnailer firefox mailspring neovim qtile qtile-extras rofi xorg xwallpaper xorg-xrdb xss-lock i3lock udiskie zathura-git zathura-cb-git zathura-djvu-git zathura-pdf-mupdf-git zathura-ps-git python-psutil python-pulsectl-asyncio starship fortune-mod gtk2 ly cups system-config-printer bluez bluez-utils bluetuith python-pip evremap --noconfirm
yay -S --noconfirm - < $wd/packages.txt

echo "Installing audio stuff (separate in case of failure)"

yay -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth pavucontrol --noconfirm
echo "Installing fonts"

#yay -S adobe-sorce-code-pro-fonts nerd-fonts ttf-ms-fonts ttf-tahoma ttf-vista-fonts ttf-fira-mono ttf-linux-libertine ttf-inconsolata noto-fonts cantarell-fonts --noconfirm
yay -S --noconfirm - < $wd/fonts.txt


echo "Installing rofi power menu"
mkdir ~/.local/bin/scripts/
cd $wd
cp rofi-power-menu ~/.local/bin/scripts/rofi-power-menu
sudo cp rofi-power-menu /usr/bin/

echo "Installing LunarVim"
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)

echo "Installing da dots and sum system config"
cd ~/Downloads/

git clone --depth=1 https://github.com/DNM1008/Dots && cd Dots

cp -r .config/* ~/.config/
cp -r .local/* ~/.local/
sudo cp 30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
# sudo echo "source /home/$user/.config/bash_profile" >> /etc/bash.bashrc
echo "source /home/$user/.config/bash/bash_profile" | sudo tee -a /etc/bash.bashrc
echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment



echo "Enabling services"


# Enabling the ly display manager
sudo systemctl enable ly
# Enabling CUPS
sudo systemctl enable cups
sudo usermod -aG lp $user
# Enabling Bluetooth
sudo systemctl enable bluetooth
echo "Installing rofi theme"
cd ~/Downloads/
git clone https://github.com/catppuccin/rofi.git
cd rofi/basic && ./install.sh



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



echo "The basic setup should be done for now, to get your system to a more
functional state, consider install pandoc and texlive, or if it's not what
you're looking for, libre office. CUPS has been installed and enabled, however,
you probably need to install the specific driver for your printer. To know what
driver you need, consult the Arch Wiki. Bluetooth is installed and should be
accessible through 'bluetoothctl' or 'bluetuith'."

read -p "Press any key to reboot"


# finishing up cleanup
#

sudo rm -r Install-Script/

reboot
