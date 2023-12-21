#!/bin/sh
#


echo "Installing yay"


mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

echo "Installing software"

#Placeholder#
yay -S --no confirmfirefox alacritty discord betterdiscord-installer copyq dunst flameshot gh gimp lxappearance lx session qt5ct htop ibus libreoffice mailspring mpv neofetch neovim ngvim olive pcmanfm picom pulseaudio qbittorrent qtile qitle-extras rofi syncthing zathura tumbler poppler-glib ffmpegthumbnailer freetype2 libgsf rawthumbnailer totem evince gnome-epub-thumbnailer mcomix
folder-preview starship xclip gnome-keyring

yay -S python-pip
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
pip install psutil
pip install pulsectl-asyncio
cd ~/Downloads

git clone https://github.com/DMN1008/Dots.git && cd Dots

cp -r .config ~/.config cp -r .local ~/.local
echo "Installing Vim Plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "Altering sudoer's bashrc to load bashrc and bash profile files in
.config"


#Placeholder
sudo echo source /home/zeus/.config/bash/bash_profile>etc/bash.bashrc
echo "Enabling nvim plugin"
#Placeholder
 
vim +'PlugInstall' +qa

echo "Installing pandoc and xelatex"
yay --noconfirm -S pandoc xelatex


echo "Installing fonts"
yay --noconfirm -S gnu-free-fonts nerd-fonts-git nerd-fonts-coomplete-mono-glyphs

echo "Running antidot and xdg ninja" 
#Placeholder
antidot clean

echo "Downloading xdg ninja"
git clone https://github.com/b3nj5m1n/xdg-ninja.git
cd xdg-ninja && ./xdg-ninja.sh

echo "It should be done, now you just have to delete the unused dotfiles in
your home directory (.bashrc, .bashprofile, .xinitrc and the .nvim directory)
echo "What's next?"
echo "The system should be ready to go, but I'd install the Firefox userChrome files in my my repo as well"
