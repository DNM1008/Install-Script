#!/bin/sh
#


echo "Installing yay"

sudo pacman --noconfirm -S git base-devel

mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay makepkg -si

echo "Installing software"

#Placeholder#
yay -S firefox alacritty discord betterdiscord-installer copyq dunst flameshot
gh gimp lxappearance lx session qt5ct htop ibus libreoffice mailspring mpv
neofetch neovim ngvim olive pcmanfm picom pulseaudio qbittorrent qtile
qitle-extras rofi syncthing zathura tumbler poppler-glib ffmpegthumbnailer
freetype2 libgsf rawthumbnailer totem evince gnome-epub-thumbnailer mcomix
folder-preview starship xclip gnome-keyring

yay -S python-pip



echo "Downloading and moving config files to appropriate locations"

cd ~/Downloads

git clone https://github.com/DMN/Dots && cd Dots

cp -r .config ~/.config cp -r .local ~/.local

echo "Altering sudoer's bashrc to load bashrc and bash profile files in
.config"

#Placeholder

echo "Enabling nvim plugin"
#Placeholder

echo "Running antidot and xdg ninja" echo "Downloading xdg ninja"
#Placeholder

antidot clean

echo "It should be done, now you just have to delete the unused dotfiles in
your home directory (.bashrc, .bashprofile, .xinitrc and the .nvim directory)
echo "What's next?" echo "The system should be ready to go, but I'd install the
Firefox userChrome files in my my repo as well"
