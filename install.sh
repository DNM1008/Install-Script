#!/bin/sh
#


echo "Installing yay"


mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Updating
yay

echo "Installing software"

#Placeholder#
yay -S  acpi alacritty alsa amixer pulseaudio pavucontrol alsa-utils cantarell-fonts catppuccin-gtk-theme-macchiato cmake cmatrix ffmpeg ffmpegthumbnailer firefox mail spring neovim qtile qtile-extras rofi xorg xwallpaper xrdb xss-lock i3lock udiskie zathura-git zathura-cb-git zathura-dj-vu zathura-pdf-mupdf-git zathura-ps-git python-psutil python-pulsectl-asyncio starship fortune-mod ly --noconfirm

echo "Installing fonts"

yay -S adobe-sorce-code-pro-fonts nerd-fonts ttf-ms-fonts ttf-tahoma ttf-vista-fonts ttf-fira-mono

echo "Installing rofi theme"
cd ~/Downloads
git clone https://github.com/catppuccin/rofi.git && cd rofi/basic

./install.sh

echo "Install dependencis for bar functionality"

yay -S python-pip

git clone https://github.com/DNM1008/Dots.git && cd Dots

cp -r .config ~/.config 


sudo systemctl enable ly

sudo echo "source /home/$user/.config/bash_profile" >> /etc/bash.bashrc



echo "Install nvChad"

git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

killall nvim

echo "The basic setup should be done for now, to get your system to a more functional state, consider install pandoc and texlive, or if it's not what you're looking for, libre office. Consider other functionalities such as bluetooth and CUPS for printing."
