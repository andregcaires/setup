#!/usr/bin/env bash
# script for minimal KDE Plasma install on Ubuntu

set -e

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    plasma-desktop \
    sddm \
    kde-config-sddm \
    konsole \
    dolphin \
    kdeplasma-addons \
    plasma-nm \
    plasma-pa \
    kdeconnect \
    kscreen \
    kwalletmanager

# sets SDDM
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure sddm

# removes possible metapackages
sudo apt purge -y kubuntu-desktop kde-standard kde-full || true
sudo apt autoremove -y
sudo apt clean

# configures auto numlock for SDDM
CONFIG_DIR="/etc/sddm.conf.d"
CONFIG_FILE="$CONFIG_DIR/numlock.conf"
echo "Numlock=on" | sudo tee -a "$CONFIG_FILE" > /dev/null

echo "[INFO] KDE Plasma minimalista instalado com sucesso!"
echo "Reinicie o sistema: sudo reboot"
