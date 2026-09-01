# Arch Linux Install Script

Automates the post-installation setup of a minimal Arch system into a fully
configured desktop. Currently targets **KDE Plasma on Wayland**; Qtile is
planned but not implemented yet (the script exits if you pick it). Pairs with
the [Dots](https://github.com/DNM1008/Dots) repository, which provides all the
configuration files.

---

## What it does

1. **Sudo caching** — asks for your password once up front and keeps it alive
   in the background, instead of prompting repeatedly through the script
2. **Desktop choice** — prompts for KDE Plasma or Qtile. Only KDE is
   implemented right now; picking Qtile exits the script.
3. **Hardware detection** — checks detected GPU(s) against `packages/core.txt`
   and offers (via a menu) to add any missing driver packages (e.g.
   `nvidia-open-dkms`, `vulkan-intel`, `vulkan-radeon`)
4. **Package group choice** — `packages/core.txt` always installs; a menu lets
   you skip any of the optional groups (dev tools, office, Wayland/tiling
   extras, VPN & sync, printing)
5. **Pacman tweaks** — enables the ILoveCandy animation and parallel downloads
6. **System update** — full sync and upgrade before installing anything
7. **base-devel** — installed via pacman so `makepkg` can build yay
8. **yay** — bootstraps the AUR helper (needed for most packages)
9. **Packages** — installs `packages/core.txt` plus whichever optional groups
   were selected, including PipeWire (KDE's default audio stack)
10. **Fonts** — installs everything in `fonts.txt`
11. **Dotfiles** — clones the Dots repo and copies `.config/` and `.local/` into
    place (Neovim config included); sets up a system-wide bash profile and Qt
    theming
12. **Services** — enables `sddm` (display manager) always; a menu lets you
    skip CUPS (printing) or Bluetooth
13. **Rofi theme** — installs the Catppuccin Macchiato rofi theme
14. **Cleanup** — removes default bash files, clears the package cache, and
    initialises antidot for XDG compliance
15. **Reboot**

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
# Optional: edit files under packages/ and fonts.txt to add or remove packages
./install.sh
```

The script asks for your sudo password once at the start, pauses a few times
for menu choices and confirmations, and pauses once more at the end before
rebooting.

---

## Customising packages

- **`packages/core.txt`** — always installed, one package name per line; both
  official and AUR packages are supported (yay handles both)
- **`packages/dev.txt`, `office.txt`, `wayland-tools.txt`, `vpn-sync.txt`,
  `printing.txt`** — optional groups; the script shows a menu to skip any of
  them at install time
- **`fonts.txt`** — same format as `packages/core.txt`; font packages are
  installed in a separate pass

Edit these before running the script to include or exclude anything. Be careful
removing packages that others depend on.

---

## Running on a desktop-ready Arch install or derivative

If you already have a working desktop (EndeavourOS, Manjaro, etc.):

- **Display manager** — disable or remove your existing DM service, or delete
  `sddm` from `packages/core.txt`. Two DMs enabled at once will cause a broken
  boot.
- **Bluetooth / printing** — already set up on most derivatives; safe to
  reinstall but it adds time, or skip them in the services/package-group
  menus.

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
