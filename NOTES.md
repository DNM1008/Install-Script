# Notes and gotchas

Running notes on things that have broken, need manual attention, or aren't
obvious from reading the script.

---

## Audio: PipeWire conflict

The audio step installs PulseAudio. If PipeWire is already installed (common on
Manjaro, EndeavourOS, and any GNOME-based install), this will fail.

To remove PipeWire before running:
```sh
sudo pacman -Rns pipewire pipewire-alsa pipewire-pulse wireplumber
```

The script installs PulseAudio separately from the main package list precisely
so a failure here doesn't abort everything else.

---

## Display manager: ly

The script enables `ly` as the display manager. If another DM is already
enabled (SDDM, GDM, LightDM), you'll get a broken boot because two DMs can't
both run.

Before running the script on a non-minimal install:
```sh
sudo systemctl disable sddm   # or gdm, lightdm, etc.
```

Or remove `ly` from `packages.txt` and enable your preferred DM manually.

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

## Multi-monitor setup

The `~/.config/qtile/autostart.sh` contains `xrandr` calls hardcoded to a
specific dual-monitor layout (eDP-1 internal + HDMI-2 external). If your
outputs are named differently or you have a different arrangement, edit that
file before your first login.

Check your output names with:
```sh
xrandr --query
```

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

## Rofi power menu

Installed to both `~/.local/bin/scripts/rofi-power-menu` and `/usr/bin/`.
If rofi can't find it, check that `~/.local/bin/scripts/` is in your `$PATH`
(it should be, via the bash profile from the Dots repo).
