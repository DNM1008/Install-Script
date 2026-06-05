#!/bin/sh
#
# Post-installation setup script for Arch Linux.
# Assumes a minimal Arch install with base-devel, git, and an active internet connection.
# See readme.md for prerequisites and NOTES.md for known issues.
set -e

user=$(whoami)
wd=$(pwd)

# ── Pacman tweaks ─────────────────────────────────────────────────────────────
# ILoveCandy replaces the progress bar with a Pac-Man animation.
echo "Making Pacman look prettier"
sudo grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Parallel downloads speeds up package installation significantly on fast connections.
echo "Enabling parallel downloads"
sudo sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf

# ── System update ─────────────────────────────────────────────────────────────
echo "Initial sync"
sudo pacman -Syyu

# ── yay (AUR helper) ──────────────────────────────────────────────────────────
# yay is needed to install packages from both the official repos and the AUR.
# It's bootstrapped manually since it isn't in the official repos.
echo "Installing yay"
mkdir ~/Downloads && cd ~/Downloads
git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si --noconfirm

# Sync and update everything via yay before installing anything else.
yay

# ── Package installation ───────────────────────────────────────────────────────
# packages.txt lists both official and AUR packages, one per line.
echo "Installing software"
yay -S --noconfirm - < $wd/packages.txt

# Audio is installed separately so that a PipeWire conflict doesn't abort the
# whole script. If this step fails, remove PipeWire first (see NOTES.md).
echo "Installing audio stuff (separate in case of failure)"
yay -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth pavucontrol --noconfirm

# fonts.txt lists font packages, kept separate so they're easy to trim.
echo "Installing fonts"
yay -S --noconfirm - < $wd/fonts.txt

# ── Rofi power menu ───────────────────────────────────────────────────────────
# Installs the custom rofi-power-menu script both for the user and system-wide
# so it's callable from rofi without a full path.
echo "Installing rofi power menu"
mkdir ~/.local/bin/scripts/
cd $wd
cp rofi-power-menu ~/.local/bin/scripts/rofi-power-menu
sudo cp rofi-power-menu /usr/bin/

# ── LunarVim ──────────────────────────────────────────────────────────────────
# LunarVim is an opinionated Neovim distribution. The dots repo contains the
# Neovim config but LunarVim provides the base layer.
echo "Installing LunarVim"
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)

# ── Dotfiles ──────────────────────────────────────────────────────────────────
# Clones the Dots repo and copies configs into place. This overwrites any
# existing files in ~/.config and ~/.local — intentional on a fresh install.
echo "Installing da dots and sum system config"
cd ~/Downloads/
git clone --depth=1 https://github.com/DNM1008/Dots && cd Dots

cp -r .config/* ~/.config/
cp -r .local/* ~/.local/

# Touchpad: enables tap-to-click system-wide via X11 config.
sudo cp 30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf

# Sources the custom bash profile for all users so XDG paths and env vars are
# available in every shell session, not just interactive ones.
echo "source /home/$user/.config/bash/bash_profile" | sudo tee -a /etc/bash.bashrc

# Forces Qt5 apps to use qt5ct for theming so they match the GTK/KDE theme.
echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment

# ── System services ───────────────────────────────────────────────────────────
echo "Enabling services"

# ly: a lightweight TUI display manager. Disable your existing DM first if
# running on a desktop-ready install (see readme.md).
sudo systemctl enable ly

# CUPS: printing support. You'll still need to install your printer's driver
# separately — consult the Arch Wiki for the right package.
sudo systemctl enable cups
sudo usermod -aG lp $user

# Bluetooth: enables the daemon. Use bluetuith (TUI) or bluetoothctl to pair.
sudo systemctl enable bluetooth

# ── Rofi Catppuccin theme ─────────────────────────────────────────────────────
echo "Installing rofi theme"
cd ~/Downloads/
git clone https://github.com/catppuccin/rofi.git
cd rofi/basic && ./install.sh

# ── Cleanup ───────────────────────────────────────────────────────────────────
echo "Cleaning up"
cd

# Apply the new bash profile so subsequent commands in this script use the
# correct paths and environment variables.
source .config/bash/bash_profile

# Remove the default bash files that were replaced by the dots config.
sudo rm -r .bash_history .bash_profile .bash_logout .bashrc

# Remove directories that get recreated cleanly by the tools themselves.
sudo rm -r .gnupg/
sudo rm -r go/

# Clear the package cache to free disk space.
yay -Scc --noconfirm
sudo rm -r ~/go

# antidot manages XDG compliance — moves config files out of $HOME into their
# proper XDG locations and keeps them there.
antidot update
antidot clean
eval "$(antidot init)"

# ── Done ──────────────────────────────────────────────────────────────────────
echo "The basic setup should be done for now, to get your system to a more
functional state, consider install pandoc and texlive, or if it's not what
you're looking for, libre office. CUPS has been installed and enabled, however,
you probably need to install the specific driver for your printer. To know what
driver you need, consult the Arch Wiki. Bluetooth is installed and should be
accessible through 'bluetoothctl' or 'bluetuith'."

read -p "Press any key to reboot"

# Remove the install script directory before rebooting.
sudo rm -r Install-Script/

reboot
