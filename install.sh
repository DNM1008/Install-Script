#!/bin/bash
#
# Post-installation setup script for Arch Linux.
# Assumes a minimal Arch install with git and an active internet connection.
# See readme.md for prerequisites and NOTES.md for known issues.
set -e

user=$(whoami)
wd=$(pwd)

# ── Sudo caching ─────────────────────────────────────────────────────────────
# Prompts for the password once up front instead of scattered throughout the
# script, then keeps the sudo timestamp alive in the background until this
# script exits.
echo "This script needs sudo for several steps — enter your password once now."
sudo -v
(
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" 2>/dev/null || exit
	done
) &
sudo_keepalive_pid=$!
trap 'kill "$sudo_keepalive_pid" 2>/dev/null' EXIT

# ── Menu UI ──────────────────────────────────────────────────────────────────
# whiptail (from libnewt) draws the ncurses boxes used for every prompt below.
# It's an official repo package so it can be installed straight away, before
# yay exists.
echo "Installing whiptail for interactive menus"
sudo pacman -S --needed --noconfirm libnewt

backtitle="Arch Install Script"

# ── Desktop/compositor choice ───────────────────────────────────────────────
# Only KDE is implemented right now. Qtile is kept as a menu option so it's
# obvious it's planned, but selecting it just exits.
choose_de() {
	de=$(whiptail --backtitle "$backtitle" --title "Desktop choice" \
		--menu "Which desktop/session do you want to set up?" 12 60 2 \
		kde "KDE Plasma (Wayland)" \
		qtile "Qtile (not yet implemented)" \
		3>&1 1>&2 2>&3)
	clear
}

choose_de

if [ "$de" = "qtile" ]; then
	echo "Qtile support isn't implemented in this script yet. Exiting."
	exit 1
fi

# ── Hardware detection ──────────────────────────────────────────────────────
# Cross-checks detected GPU(s) against packages/core.txt and offers to append
# any missing driver packages. Doesn't touch anything without confirmation.
recommend_gpu_packages() {
	local gpu_info recommended=()
	gpu_info=$(lspci -k | grep -iE 'vga compatible controller|3d controller|display controller')

	if echo "$gpu_info" | grep -qi nvidia; then
		recommended+=(nvidia-open-dkms libva-nvidia-driver envycontrol)
		echo "$gpu_info" | grep -qi intel &&
			recommended+=(plasma6-applets-optimus-gpu-switcher-git)
	fi
	if echo "$gpu_info" | grep -qi intel; then
		recommended+=(mesa vulkan-intel intel-media-driver)
	fi
	if echo "$gpu_info" | grep -qiE 'amd|advanced micro devices|radeon'; then
		recommended+=(mesa vulkan-radeon xf86-video-amdgpu)
	fi

	local missing=()
	for pkg in "${recommended[@]}"; do
		grep -qx "$pkg" "$wd/packages/core.txt" || missing+=("$pkg")
	done

	if [ "${#missing[@]}" -eq 0 ]; then
		whiptail --backtitle "$backtitle" --title "GPU packages" \
			--msgbox "Detected:\n${gpu_info}\n\nNo additional GPU packages recommended — packages/core.txt already covers detected hardware." 15 70
		clear
		return
	fi

	if whiptail --backtitle "$backtitle" --title "GPU packages" \
		--yesno "Detected:\n${gpu_info}\n\nBased on your GPU(s), consider adding these packages:\n${missing[*]}\n\nAdd them to packages/core.txt now?" 18 70; then
		printf '%s\n' "${missing[@]}" >>"$wd/packages/core.txt"
	fi
	clear
}

recommend_gpu_packages

# ── Optional package groups ─────────────────────────────────────────────────
# packages/core.txt always installs. Everything else under packages/ is an
# optional group the user can skip.
group_labels=("Development tools" "Office & documents" "VPN & sync" "Printing")
group_files=("dev.txt" "office.txt" "vpn-sync.txt" "printing.txt")
selected_group_files=()

choose_package_groups() {
	local checklist_args=()
	local i
	for i in "${!group_labels[@]}"; do
		checklist_args+=("${group_files[$i]}" "${group_labels[$i]}" "on")
	done

	local chosen
	chosen=$(whiptail --backtitle "$backtitle" --title "Optional package groups" \
		--separate-output \
		--checklist "Space to toggle, Enter to confirm:" 18 70 "${#group_labels[@]}" \
		"${checklist_args[@]}" \
		3>&1 1>&2 2>&3)
	clear

	while IFS= read -r file; do
		[ -n "$file" ] && selected_group_files+=("$wd/packages/$file")
	done <<<"$chosen"
}

choose_package_groups

# ── Pacman tweaks ─────────────────────────────────────────────────────────────
# ILoveCandy replaces the progress bar with a Pac-Man animation.
echo "Making Pacman look prettier"
sudo grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Parallel downloads speeds up package installation significantly on fast connections.
echo "Enabling parallel downloads"
sudo sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf

# ── Locale ─────────────────────────────────────────────────────────────────────
# en_GB.UTF-8 isn't generated on a minimal Arch install, which makes glibc
# complain ("setlocale: LC_ALL cannot honor request") for the rest of the
# script and every session after. Falls back to en_US.UTF-8, which is always
# present as a commented-out entry in locale.gen.
echo "Configuring locale (falling back to en_US.UTF-8)"
sudo sed -i "s/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sudo locale-gen
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ── System update ─────────────────────────────────────────────────────────────
echo "Initial sync"
sudo pacman -Syyu

# ── base-devel ─────────────────────────────────────────────────────────────────
# Needed by makepkg to build yay (and anything else from the AUR).
echo "Installing base-devel"
sudo pacman -S --needed --noconfirm base-devel

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
# packages/core.txt plus whichever optional groups were selected above.
echo "Installing software"
cat "$wd/packages/core.txt" "${selected_group_files[@]}" | yay -S --needed --noconfirm -

# fonts.txt lists font packages, kept separate so they're easy to trim.
echo "Installing fonts"
yay -S --needed --noconfirm - <"$wd/fonts.txt"

# ── Dotfiles ──────────────────────────────────────────────────────────────────
# Clones the Dots repo and copies configs into place. This overwrites any
# existing files in ~/.config and ~/.local — intentional on a fresh install.
echo "Installing da dots and sum system config"
cd ~/Downloads/
git clone --depth=1 https://github.com/DNM1008/Dots && cd Dots

cp -r .config/* ~/.config/
cp -r .local/* ~/.local/

# Sources the custom bash profile for all users so XDG paths and env vars are
# available in every shell session, not just interactive ones.
echo "source /home/$user/.config/bash/bash_profile" | sudo tee -a /etc/bash.bashrc

# Forces Qt5 apps to use qt5ct for theming so they match the GTK/KDE theme.
echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment

# gtkrc-janitor: a user systemd service (from .config/systemd/user/) that
# deletes stray legacy GTK1/GTK2 rc files kde-gtk-config keeps regenerating.
# Needs its own enable — copying the unit file into place doesn't start it.
echo "Enabling gtkrc-janitor"
systemctl --user daemon-reload
systemctl --user enable --now gtkrc-janitor.service

# ── Shell ────────────────────────────────────────────────────────────────────
# Switches the login shell to zsh and points ZDOTDIR at the XDG-compliant
# config location the Dots repo uses.
echo "Switching to zsh"
sudo chsh -s /bin/zsh "$user"
echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zsh/zshenv

# ── System services ───────────────────────────────────────────────────────────
# sddm is always enabled — KDE needs a display manager to reach a session.
echo "Enabling sddm"
sudo systemctl enable sddm

# CUPS and Bluetooth are optional — toggle them off if you don't need them.
service_labels=("CUPS (printing)" "Bluetooth")
service_units=("cups" "bluetooth")

choose_services() {
	local checklist_args=()
	local i
	for i in "${!service_labels[@]}"; do
		checklist_args+=("${service_units[$i]}" "${service_labels[$i]}" "on")
	done

	local chosen
	chosen=$(whiptail --backtitle "$backtitle" --title "Optional services" \
		--separate-output \
		--checklist "Space to toggle, Enter to confirm:" 12 60 "${#service_labels[@]}" \
		"${checklist_args[@]}" \
		3>&1 1>&2 2>&3)
	clear

	while IFS= read -r unit; do
		[ -n "$unit" ] || continue
		echo "Enabling $unit"
		sudo systemctl enable "$unit"
	done <<<"$chosen"
}

choose_services

# CUPS needs the user in the `lp` group regardless of whether it was enabled
# above, since packages/printing.txt may have been installed either way.
sudo usermod -aG lp "$user"

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

read -r -p "Press any key to reboot"

# Remove the install script directory before rebooting.
sudo rm -r Install-Script/

reboot
