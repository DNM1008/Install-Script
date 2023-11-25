#!/bin/sh
#


echo "Installing yay"

sudo pacman -S git base-devel

mkdir ~/Downloads && cd ~/Downloads

git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si

echo "Installing software"

#Placeholder#


echo "Downloading and moving config files to appropriate locations"

cd ~/Downloads

git clone https://github.com/DMN/Dots && cd Dots

cp -r .config ~/.config
cp -r .local ~/.local

echo "Altering sudoer's bashrc to load bashrc and bash profile files in .config"

#Placeholder

echo "Enabling nvim plugin"
#Placeholder

echo "Running antidot and xdg ninja"
echo "Downloading xdg ninja"
#Placeholder

antidot clean

echo "It should be done, now you just have to delete the unused dotfiles in your home directory (.bashrc, .bashprofile, .xinitrc and the .nvim directory)

