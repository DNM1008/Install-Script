# Notes and gotchas

Running notes on things that have broken, need manual attention, or aren't
obvious from reading the script.

---

## Locale: en_GB.UTF-8 not available

A minimal Arch install only ships `en_US.UTF-8` uncommented (as a
commented-out option) in `/etc/locale.gen` — `en_GB.UTF-8` isn't generated,
which causes `setlocale: LC_ALL: cannot change locale` warnings if `LANG` or
`LC_ALL` is set to it anywhere (shell profile, environment, etc.). The script
generates and switches to `en_US.UTF-8` instead. If you actually want
`en_GB.UTF-8`, uncomment it in `/etc/locale.gen`, run `sudo locale-gen`, and
set `LANG=en_GB.UTF-8` in `/etc/locale.conf` after the script finishes.

---

## gtkrc-janitor (user service)

KDE's `kde-gtk-config` keeps regenerating legacy `.gtkrc`/`.gtkrc-2.0` files
in `$HOME` and `$HOME/.config` even though nothing reads them. The Dots repo
ships a user systemd service (`~/.config/systemd/user/gtkrc-janitor.service`)
plus `~/.local/bin/gtkrc-janitor.sh` that deletes them on sight via
`inotifywait`. It's a *user* unit, not a system one, so `systemctl enable`
won't touch it — the script runs `systemctl --user enable --now` right after
the dotfiles are copied in. Check it's running with:
```sh
systemctl --user status gtkrc-janitor.service
```

---

## Display manager: sddm

The script enables `sddm` as the display manager (KDE's default). If another
DM is already enabled (GDM, LightDM, ly), you'll get a broken boot because two
DMs can't both run.

Before running the script on a non-minimal install:
```sh
sudo systemctl disable gdm   # or lightdm, ly, etc.
```

Or remove `sddm` from `packages/core.txt` and enable your preferred DM
manually.

---

## GPU detection

The script greps `lspci -k` for VGA/3D/display controllers and recommends
driver packages based on vendor strings (`nvidia`, `intel`, `amd`/`radeon`).
It only appends to `packages/core.txt` if you pick that option from the menu —
it never installs anything on its own. If your GPU isn't detected correctly,
add the driver packages to `packages/core.txt` manually before running.

---

## Optional package groups and services

`packages/core.txt` always installs. The other files under `packages/`
(`dev.txt`, `office.txt`, `wayland-tools.txt`, `vpn-sync.txt`, `printing.txt`)
are offered as a skip-list menu at install time — press Enter to install all
of them, or type the numbers of any you want to skip.

The same pattern is used for services after sddm is enabled: CUPS and
Bluetooth can be skipped from a menu. Note that skipping the `printing.txt`
package group does *not* automatically skip the CUPS service prompt (they're
independent choices) — skip both if you don't want printing at all.

---

## Sudo caching

The script runs `sudo -v` once at the start and keeps a background loop
alive (`sudo -n true` every 60s) so later `sudo` calls in the script don't
re-prompt. The loop is killed via a `trap ... EXIT` when the script exits,
including on error. If you interrupt the script (Ctrl-C) before that trap
fires, kill any leftover loop manually with `pkill -f 'sudo -n true'`.

---

## Default terminal in Thunar / KDE

The script does not configure which terminal emulator Thunar or KDE use when
opening terminal applications (files with `Terminal=true` in their `.desktop`
entry).

On KDE, the default is Konsole. To change it to Kitty:

1. **KDE system setting** (often ignored by Thunar):
   ```sh
   kwriteconfig5 --file kdeglobals --group General --key TerminalApplication kitty
   kwriteconfig5 --file kdeglobals --group General --key TerminalService kitty.desktop
   ```

2. **exo-open** (what Thunar actually uses for "Open Terminal Here"):
   Set `TerminalEmulator=kitty` in `~/.config/xfce4/helpers.rc`

3. **For files that open in a terminal app** (e.g. nvim via Thunar):
   Create a local desktop override that bypasses the `Terminal=true` delegation:
   ```sh
   cp /usr/share/applications/nvim.desktop ~/.local/share/applications/nvim.desktop
   ```
   Then set `Terminal=false` and `Exec=kitty nvim %F` in that file.
   ```sh
   update-desktop-database ~/.local/share/applications/
   ```

The root cause: `Terminal=true` in a `.desktop` file tells the launcher to wrap
the command in a terminal. KDE's launcher defaults to Konsole regardless of
other terminal settings, especially when a GTK app (Thunar) triggers the launch
via a mix of exo and KDE's klauncher.

---

## Thunar custom actions (uca.xml)

The "Open Terminal Here" action in Thunar is defined in
`~/.config/Thunar/uca.xml`. The Dots repo ships this file. Make sure the
`<command>` line uses the terminal you want — it doesn't automatically follow
the system default.

Current default in the Dots repo:
```xml
<command>kitty --working-directory %f</command>
```

---

## antidot

antidot moves config files out of `$HOME` into their proper XDG locations. It
runs at the end of the script. If any tool re-creates files in `$HOME` after
the script finishes, run `antidot clean` again manually.

---

## Multi-monitor setup (Qtile, not yet implemented)

The old Qtile config used hardcoded `xrandr` calls in
`~/.config/qtile/autostart.sh` for a specific dual-monitor layout. Not
relevant to the current KDE path — KDE's System Settings handles multi-monitor
layout directly. This note is kept for whenever Qtile support is built out.

---

## Printer

CUPS is installed and enabled. You still need the driver for your specific
printer. The Arch Wiki has a full list:
https://wiki.archlinux.org/title/CUPS

---

## Qt theming

`QT_QPA_PLATFORMTHEME=qt5ct` is appended to `/etc/environment` so Qt5 apps
use qt5ct for theming system-wide. The theme itself (Catppuccin Macchiato) is
configured in `~/.config/qt5ct/` via the Dots repo.

If Qt apps look wrong after install, check that qt5ct is installed and that
the environment variable is present:
```sh
cat /etc/environment
```

---
