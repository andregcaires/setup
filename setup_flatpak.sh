#!/bin/bash

install_flatpak() {
    if ! command -v flatpak --version >/dev/null 2>&1
    then
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        sudo reboot
    fi
}
