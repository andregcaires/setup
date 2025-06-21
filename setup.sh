#!/bin/bash

install_os_specific_apps() {
    if [ -f "/etc/debian_version" ]; then
        echo "'Debian' distro..."
        sudo apt update
        sudo apt install curl git -y
        
        ## vscode
        sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        rm -f packages.microsoft.gpg
        sudo apt install apt-transport-https -y
        sudo apt update
        sudo apt install code -y

    fi
}

install_through_snap() {
    if ! command -v snap --version >/dev/null 2>&1
    then
        echo "snap not found"
    else
        echo "snap was found"
    fi
}

install_through_online_scripts() {
    ## SDKMAN  
    if ! command -v sdkman version >/dev/null 2>&1
    then
    	curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        echo "sdkman was found"
    fi

    ## FNM 
    if ! command -v fnm --version >/dev/null 2>&1
    then
    	curl -fsSL https://fnm.vercel.app/install | bash 
    else
        echo "fnm was found"
    fi
    
    ## Rust
    if ! command -v rustup --version >/dev/null 2>&1
    then
    	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo "rustup was found"
    fi

    # VS Code extensions 
    curl -fsSL https://raw.githubusercontent.com/andregcaires/setup/refs/heads/master/vscode-setup.sh | bash 
}

echo "Starting setup..."
install_os_specific_apps
install_through_snap
install_through_online_scripts
echo "...setup done!"
