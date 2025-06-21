#!/bin/bash

install_os_specific_apps() {
    if [ -f "/etc/debian_version" ]; then
        echo "'Debian' distro..."
        sudo apt update
        sudo apt install git -y
    fi
}

install_through_snap() {
    if ! command -v snap --version >/dev/null 2>&1
    then
        echo "snap not found, proceeding installation with apt"
        # TODO 
    else
        echo "snap was found"
        sudo snap install curl
        sudo snap install code --classic
    fi
}

install_through_online_scripts() {
    ## SDKMAN for Java    
    if ! command -v sdkman version >/dev/null 2>&1
    then
    	curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        echo "sdkman was found"
    fi

    ## FNM for Node.js
    if ! command -v fnm --version >/dev/null 2>&1
    then
    	curl -fsSL https://fnm.vercel.app/install | bash ## deu ruim
    else
        echo "fnm was found"
    fi
    
    ## Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

echo "Starting setup..."
install_os_specific_apps
install_through_snap
install_through_online_scripts
echo "...setup done!"
