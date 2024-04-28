#!/bin/sh
#


echo "Installing yay"


mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Updating
yay

echo "Installing software"

#Placeholder#
yay -S  acpi alacritty alsa amixer pulseaudio pavucontrol alsa-utils cantarell-fonts catppuccin-gtk-theme-macchiato cmake cmatrix ffmpeg ffmpegthumbnailer firefox mail spring neovim qtile qtile-extras rofi xorg xwallpaper xrdb xss-lock i3lock udiskie zathura-git zathura-cb-git zathura-dj-vu zathura-pdf-mupdf-git zathura-ps-git

echo "Installing fonts"

yay -S adobe-sorce-code-pro-fonts nerdfonts ttf-ms-fonts ttf-tahoma ttf-vista-fonts ttf-fira-mono

echo "Installing rofi theme"
cd ~/Downloads
git clone https://github.com/catppuccin/rofi.git && cd rofi/basic

./install.sh

echo "Install dependencis for bar functionality"

yay -S python-pip
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
pip install psutil
pip install pulsectl-asyncio
cd ~/Downloads

git clone https://github.com/DNM1008/Dots.git && cd Dots

cp -r .config ~/.config 

echo "Install nvChad"

git clone https://github.com/NvChad/starter ~/.config/nvim && nvim



sudo echo "source /home/$user/.config/bash_profile" >> /etc/bash.bashrc

echo "Defining the QT variable (it should be defined in bash_profile, but sometimes it doesn't work :)) :"

sudo echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment


echo "The basic setup should be done for now, to get your system to a more functional state, consider install pandoc and texlive, or if it's not what you're looking for, libre office. Consider other functionalities such as bluetooth and CUPS for printing."
