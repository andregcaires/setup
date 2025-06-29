#!/bin/bash

install_flatpak() {
    if ! command -v flatpak --version >/dev/null 2>&1
    then
        echo "flatpak not found, must install and reboot afterwards"
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        sudo reboot
    else
        echo "flatpak already installed"
    fi
}

install_flatpak_apps() {

    flatpak install com.spotify.Client com.getpostman.Postman com.valvesoftware.Steam -y
}

install_flatpak
install_flatpak_apps
