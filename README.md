# Install script for me [dots](https://github.com/DNM1008/Dots)!

Preparation:

* This script is written with Arch in mind. You can probably get away with
running it on an Arch derivative, but I cannot guarantee that it will work. You
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
* Clone this repo
* Run `install.sh`
* Press Enter a bunch of times :) (I might have a script in the future that
doesn't require pressing Enter)

Additional Configurations:

This is 99% my Linux setup. However, there is a small (but perhaps the most
important) part, which is the keymap. I thought about having it setup from the
get go, but it's kinda difficult, and I also have a system where I configured
my keyboard by VIA, making the configuration unnecessary. If you don't have
that (for example on a laptop), the config file is still in
`~/.config/evremap/evremap.toml`. What you might want to do is install
`evremap`. From there, you have a few options:

* Download and put `evremap.service` in `/usr/lib/systemd/system/`, then either
put `evremap.toml` in `/etc/evremap.toml` or put a symlink there that points
towards wherever you put `evremap.toml` (again, the default location is
`~/.config/evremap/evremap.toml`).
* Edit `evremap.service` so that it points directly to your config file, then
put it in `/usr/lib/systemd/system/`. The line that you want to look at is
`ExecStart=bash -c "/usr/bin/evremap remap /etc/evremap.toml -d 0`. Change
`/etc/evremap.toml` to wherever you put your config file. Note that you will
have to use the **full** path, that is, if you want to point it to the default
location, the location would have to be `/home/<your
username>/.config/evremap/evremap.toml`. You can find your user name by running
`whoami`. It's basically your login name.

**Note:** You should take a look at the script and see what it's doing. I am
not good at coding and you might be able to improve it (very likely) and/or
tweak it to your liking (also very likely).
