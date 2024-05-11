# Install script for me [dots](https://github.com/DNM1008/Dots)!

Preparation:

* This script is written with Arch in mind. Tested on a fresh Arch install. You
won't be able to run this on anything Debian or Fedora-related, this script
utilises `pacman` and the AUR. It will install `yay` and then go from there. I
might write a script that works on Debian in the future :).

* Before running this script, make sure that the followings are correct:
    * `base-devel` is installed. If you're using something like EndeavourOS or
    Manjaro, chances are it's already been taken care of, but if you're using
    mainline Arch, make sure that you have that installed. This is essential
    anyway, since it allows things like `make` and `sudo`, among other things.
    * `git` is installed.
    * You are not using Pipewire. This script will install Pulseaudio, and
    having 2 audio servers (or 2 or more of anything that does the same thing)
    is kinda a no no. Why Pulseaudio over Pipewire? Qtile as of the time of
    writing doesn't support changing volume with Pipewire. I will probably
    switch to Pipewire once that functionality is up and going on Qtile. If you
    are already using Pipewire already, google how to disable Pipewire. The
    script will install and enable Pulseaudio.
        * If you're running this script from Manajaro or EndeavourOS or anything like that, check if Pipewire is installed. The installation will fail if there is Pipewire of any kind on the system.
    * You are connected to the internet. This is probably more for me, but you
    want to check if you have 2 or more network services running. For instance,
    if you installed Network Manager (like a human being) and enabled it, you
    want to disable systemd-networkd and iwd (again, having 2 or more services
    doing the same thing is kinda a big no no)>
    * You are comfortable with a more "keyboard driven" workflow. The fact that
    you're using Arch probably means that you are probably comfortable with
    using the keyboard for everything, but if you're just hopping from GNOME or
    Windows, I'd suggest you have a read up about standalone window managers
    and their spiel, just to avoid nasty surprises. You may want to look at my
    [dots](https://github.com/DNM1008/Dots) repo to see the default keybinds.
    * This is the most important, you're prepared to have fun tinkering your
    computer :D.


To install:
* On a minimal Arch install:
    * Clone this repo
    * (Optional): View and edit the packages.txt and fonts.txt to include/exclude the packages that you want. Not that you might break dependencies
    * Run `install.sh`
    * Press Enter a few times :) (I might have a script in the future that
doesn't require pressing Enter)
* On a more desktop ready Arch install or any of the Arch derivatives: Do this before cloning and running the script:
    * Disable your display manager service if you have one enabled (something like SDDM or GDM or LightDM) or delete the line `ly` in `packages.txt`. As is, this script will try and install ly for you.
    * Chances are that you already have bluetooth and/or printer set up, so delete those from the packages file as well. (Reinstall and re-enable should technically not hurt, though it would take more time).


* This script install my keymap, which move Capslock to where Escape is, then shift Escape and Tab down (Tab would be Escape, Capslock would be Tab) and maps PgUp and PgDn to Back and Forward (I use a T430 which have PgUp and PgDn next to the Up arrow). You can disable the service out right by `sudo systemctle disable evremap` or edit the config file at `/etc/evremap.toml`.

**Note:** You should take a look at the script and see what it's doing. I am
not good at coding and you might be able to improve it (very likely) and/or
tweak it to your liking (also very likely).
