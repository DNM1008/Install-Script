# Arch Linux Install Script

Automates the post-installation setup of a minimal Arch system into a fully
configured Qtile desktop. Pairs with the
[Dots](https://github.com/DNM1008/Dots) repository, which provides all the
configuration files.

---

## What it does

1. **Pacman tweaks** — enables the ILoveCandy animation and parallel downloads
2. **System update** — full sync and upgrade before installing anything
3. **yay** — bootstraps the AUR helper (needed for most packages)
4. **Packages** — installs everything in `packages.txt` via yay
5. **Audio** — installs PulseAudio separately so a PipeWire conflict doesn't
   abort the whole script
6. **Fonts** — installs everything in `fonts.txt`
7. **Rofi power menu** — copies the custom power menu script to
   `~/.local/bin/scripts/` and `/usr/bin/`
8. **LunarVim** — installs the LunarVim Neovim distribution
9. **Dotfiles** — clones the Dots repo and copies `.config/` and `.local/` into
   place; sets up tap-to-click, a system-wide bash profile, and Qt theming
10. **Services** — enables `ly` (display manager), CUPS (printing), and
    Bluetooth
11. **Rofi theme** — installs the Catppuccin Macchiato rofi theme
12. **Cleanup** — removes default bash files, clears the package cache, and
    initialises antidot for XDG compliance
13. **Reboot**

---

## Prerequisites

- A minimal Arch install (or an Arch derivative — see caveats below)
- `base-devel` installed
- `git` installed
- Active internet connection with only one network manager running (if you have
  both NetworkManager and systemd-networkd enabled, disable the one you're not
  using)
- **No PipeWire** — the script installs PulseAudio; having both causes
  conflicts. If PipeWire is present, remove it before running the script

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
  `ly` from `packages.txt`. Two DMs enabled at once will cause a broken boot.
- **Bluetooth / printing** — already set up on most derivatives; safe to
  reinstall but it adds time.
- **PipeWire** — most desktop-ready installs ship PipeWire. Remove it before
  running or the audio step will fail.

---

## After the reboot

These are not handled by the script and need to be done manually:

- **Printer driver** — CUPS is installed and enabled, but you need the
  driver for your specific printer. Check the Arch Wiki for the right package.
- **Office suite** — install `pandoc` + `texlive` for document work, or
  `libreoffice` for a full suite.
- **Default terminal** — see NOTES.md; the script doesn't configure which
  terminal KDE or Thunar use.
- **Display configuration** — if you have multiple monitors, adjust the
  `xrandr` calls in `~/.config/qtile/autostart.sh` to match your setup.
- **Bluetooth pairing** — use `bluetuith` (TUI) or `bluetoothctl` to pair
  devices.

---

## Related repositories

| Repo | Purpose |
|------|---------|
| [Dots](https://github.com/DNM1008/Dots) | All configuration files deployed by this script |
| [Arch Install](../arch_install) | Base Arch installation guide (before this script) |
