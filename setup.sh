#!/bin/bash

echo "Starting setup..."
if [ -f "/etc/debian_version" ]; then
echo "... found 'Debian' distro..."
sudo apt update

## SNAP 
sudo snap install curl spotify postman

## SNAP classic
sudo snap install code --classic

## APT 
sudo apt install git -y

## SDKMAN for Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

## FNM for Node.js
curl -fsSL https://fnm.vercel.app/install | bash ## deu ruim

## Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
echo "... setup finished!"
