# Notes and gotchas

Running notes on things that have broken, need manual attention, or aren't
obvious from reading the script.

---

## Display manager: sddm

The script enables `sddm` as the display manager (KDE's default). If another
DM is already enabled (GDM, LightDM, ly), you'll get a broken boot because two
DMs can't both run.

Before running the script on a non-minimal install:
```sh
sudo systemctl disable gdm   # or lightdm, ly, etc.
```

Or remove `sddm` from `packages.txt` and enable your preferred DM manually.

---

## GPU detection

The script greps `lspci -k` for VGA/3D/display controllers and recommends
driver packages based on vendor strings (`nvidia`, `intel`, `amd`/`radeon`).
It only appends to `packages.txt` if you confirm the prompt — it never
installs anything on its own. If your GPU isn't detected correctly, add the
driver packages to `packages.txt` manually before running.

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

## LunarVim

LunarVim is pinned to `release-1.4/neovim-0.9`. If that branch is removed
upstream, the curl install will fail silently or error. Check
https://github.com/LunarVim/LunarVim for the current recommended install
command.

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
