# Install script for me [dots](https://github.com/DNM1008/Dots)!

Preparation:

* This script is written with Arch in mind. You can probably get away with
  running it on an Arch derivative, but I cannot guarantee that it will work.
  You won't be able to run this on anything Debian or Fedora-related, this
  script utilises `pacman` and the AUR. It will install `yay` and then go from
  there. I might write a script that works on Debian in the future :).

* Before running this script, make sure that the followings are correct:
    * `base-devel` is installed. If you're using something like EndeavourOS or
      Manjaro, chances are it's already been taken care of, but if you're using
      mainline Arch, make sure that you have that installed. This is essential
      anyway, since it allows things like `make` and `sudo`, among other
      things.
    * `git` is installed.
    * You are not using Pipewire. This script will install Pulseaudio, and
      having 2 audio servers (or 2 or more of anything that does the same
      thing) is kinda a no no. Why Pulseaudio over Pipewire? Qtile as of the
      time of writing doesn't support changing volume with Pipewire. I will
      probably switch to Pipewire once that functionality is up and going on
      Qtile. If you are already using Pipewire already, google how to disable
      Pipewire. The script will install and enable Pulseaudio.
    * You are connected to the internet. This is probably more for me, but you
      want to check if you have 2 or more network services running. For
      instance, if you installed Network Manager (like a human being) and
      enabled it, you want to disable systemd-networkd and iwd (again, having 2
      or more services doing the same thing is kinda a big no no)>
    * Disable your display manager (SDDM or LightDM). The script will install
      and enable `ly`, a more lightweight solution (I will admit that it's not
      as pretty, but it's light and get the job done without looking *too*
      barebone).
    * You are comfortable with a more "keyboard driven" workflow. The fact that
      you're using Arch probably means that you are probably comfortable with
      using the keyboard for everything, but if you're just hopping from GNOME
      or Windows, I'd suggest you have a read up about standalone window
      managers and their spiel, just to avoid nasty surprises. You may want to
      look at my [dots](https://github.com/DNM1008/Dots) repo to see the
      default keybinds.
    * This is the most important, you're prepared to have fun tinkering your
      computer :D.


To install:
* Clone this repo
* Run `install.sh` with sudo priviledges since we are installing software.

**Note:** You should take a look at the script and see what it's doing. I am
not good at coding and you might be able to improve it (very likely) and/or
tweak it to your liking (also very likely).
