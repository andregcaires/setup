#!/bin/bash

sudo apt-get purge --auto-remove ubuntu-gnome-desktop
sudo apt-get autoremove 

sudo apt install kde-standard -y