#!/usr/bin/env bash

set -e

apt update && apt upgrade -y

apt purge -y ubuntu-desktop gnome-shell gdm3 gnome-software \
    gnome-control-center gnome-terminal gnome-system-monitor \
    gnome-screenshot gnome-maps gnome-calendar


apt purge -y libreoffice* thunderbird rhythmbox \
    transmission-* simple-scan cheese \
    remmina shotwell aisleriot gnome-mines gnome-sudoku \
    gnome-mahjongg gnome-todo \
    amazon-*


snap list --all || true
snap remove --purge firefox || true
snap remove --purge snap-store || true
snap remove --purge gnome-3* gtk-common-themes || true
snap remove --purge core* || true

apt purge -y snapd


# blocks snapd auto reinstall
cat <<EOF > /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

apt purge -y *gnome gonme*


apt autoremove -y
apt clean

