# Arch Linux Install Script

Automates the post-installation setup of a minimal Arch system into a fully
configured desktop. Currently targets **KDE Plasma on Wayland**; Qtile is
planned but not implemented yet (the script exits if you pick it). Pairs with
the [Dots](https://github.com/DNM1008/Dots) repository, which provides all the
configuration files.

---

## What it does

1. **Desktop choice** — prompts for KDE Plasma or Qtile. Only KDE is
   implemented right now; picking Qtile exits the script.
2. **Hardware detection** — checks detected GPU(s) against `packages.txt` and
   offers to append any missing driver packages (e.g. `nvidia-open-dkms`,
   `vulkan-intel`, `vulkan-radeon`)
3. **Pacman tweaks** — enables the ILoveCandy animation and parallel downloads
4. **System update** — full sync and upgrade before installing anything
5. **base-devel** — installed via pacman so `makepkg` can build yay
6. **yay** — bootstraps the AUR helper (needed for most packages)
7. **Packages** — installs everything in `packages.txt` via yay, including
   PipeWire (KDE's default audio stack)
8. **Fonts** — installs everything in `fonts.txt`
9. **LunarVim** — installs the LunarVim Neovim distribution
10. **Dotfiles** — clones the Dots repo and copies `.config/` and `.local/` into
    place; sets up a system-wide bash profile and Qt theming
11. **Services** — enables `sddm` (display manager), CUPS (printing), and
    Bluetooth
12. **Rofi theme** — installs the Catppuccin Macchiato rofi theme
13. **Cleanup** — removes default bash files, clears the package cache, and
    initialises antidot for XDG compliance
14. **Reboot**

---

## Prerequisites

- A minimal Arch install (or an Arch derivative — see caveats below)
- `git` installed (`base-devel` is installed by the script itself)
- Active internet connection with only one network manager running (if you have
  both NetworkManager and systemd-networkd enabled, disable the one you're not
  using)

---

## How to run

```sh
git clone https://github.com/DNM1008/Install-Script
cd Install-Script
# Optional: edit packages.txt and fonts.txt to add or remove packages
./install.sh
```

The script will pause a few times for confirmations and once at the end before
rebooting.

---

## Customising packages

- **`packages.txt`** — one package name per line; both official and AUR
  packages are supported (yay handles both)
- **`fonts.txt`** — same format; font packages are installed in a separate pass

Edit these before running the script to include or exclude anything. Be careful
removing packages that others depend on.

---

## Running on a desktop-ready Arch install or derivative

If you already have a working desktop (EndeavourOS, Manjaro, etc.):

- **Display manager** — disable or remove your existing DM service, or delete
  `sddm` from `packages.txt`. Two DMs enabled at once will cause a broken boot.
- **Bluetooth / printing** — already set up on most derivatives; safe to
  reinstall but it adds time.

---

## After the reboot

These are not handled by the script and need to be done manually:

- **Printer driver** — CUPS is installed and enabled, but you need the
  driver for your specific printer. Check the Arch Wiki for the right package.
- **Office suite** — install `pandoc` + `texlive` for document work, or
  `libreoffice` for a full suite.
- **Default terminal** — see NOTES.md; the script doesn't configure which
  terminal KDE or Thunar use.
- **Display configuration** — KDE's System Settings handles multi-monitor
  layout; no manual `xrandr` setup needed like the old Qtile config required.
- **Bluetooth pairing** — use `bluetuith` (TUI) or `bluetoothctl` to pair
  devices.

---

## Related repositories

| Repo | Purpose |
|------|---------|
| [Dots](https://github.com/DNM1008/Dots) | All configuration files deployed by this script |
| [Arch Install](../arch_install) | Base Arch installation guide (before this script) |
