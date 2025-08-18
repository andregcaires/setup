#!/bin/bash

## TODO
# add some dynamic versioning in Go installation

set -e

package_list=("sudo" "curl" "git" "zip" "unzip" "wget" "gpg" "podman")

install_via_apt() {
    echo "installing via apt"

	sudo apt update
    for package in ${package_list[@]}; do
        sudo apt install $package -y
    done

    ## VS Codium
    if ! command -v codium >/dev/null 2>&1
    then
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
            | gpg --dearmor \
            | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

        echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
            | sudo tee /etc/apt/sources.list.d/vscodium.sources

        sudo apt update && sudo apt install codium
    else
        echo "vscodium was found"
    fi

    ## python 
    if ! command -v python3 >/dev/null 2>&1
    then
        sudo apt install python3 -y
    else
        echo "python3 was found"
    fi

    if ! command -v pip >/dev/null 2>&1
    then
        sudo apt install python3-pip python3-venv -y
    else
        echo "pip was found"
    fi
}

install_via_pacman() {
    # TODO add more packages 
    echo "installing via pacman"
    for package in ${package_list[@]}; do
        pacman -S $package
    done

    pacman -S firefox openssh base-devel 
}

install_os_specific_apps() {
    if command -v apt >/dev/null 2>&1
    then
	    install_via_apt
    elif command -v pacman >/dev/null 2>&1
    then
        install_via_pacman        
    fi
}

install_through_ppas() {

    if command -v apt >/dev/null 2>&1
    then
        ## google chrome
        if ! command -v google-chrome-stable >/dev/null 2>&1
        then
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
            sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
            sudo apt-get update
            sudo apt-get install google-chrome-stable
        else
            echo "google-chrome-stable was found"
        fi

        ## microsoft edge
        if ! command -v microsoft-edge-stable >/dev/null 2>&1
        then
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
            sudo rm microsoft.gpg

            sudo apt update && sudo apt install microsoft-edge-stable
        else
            echo "microsoft-edge-stable was found"
        fi

        ## vscode
        if ! command -v code >/dev/null 2>&1
        then
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f packages.microsoft.gpg
            sudo apt install apt-transport-https -y
            sudo apt update
            sudo apt install code -y
        else
            echo "code was found"
        fi

        ## docker
        if ! command -v docker >/dev/null 2>&1
        then
            sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            sudo apt update
            sudo apt install docker-ce docker-ce-cli containerd.io -y

            sudo groupadd docker
            sudo usermod -aG docker $USER
            newgrp docker # To activate the group change without logging out and in
        else
            echo "docker was found"
        fi
    else 
        echo "apt not found"
    fi
}

install_external_tools() {
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
        . "$HOME/.cargo/env"  
        sudo apt install build-essential -y
    else
        echo "rustup was found"
    fi

    ## Go
    if ! command -v go --version >/dev/null 2>&1
    then
        curl -LO https://go.dev/dl/go1.25.0.linux-amd64.tar.gz

        sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz

        # configuring env var
        echo -e "export PATH=\$PATH:/usr/local/go/bin\nexport GOPATH=\$HOME/go\nexport PATH=\$PATH:\$GOPATH/bin" | sudo tee /etc/profile.d/go.sh > /dev/null

        sudo chmod +x /etc/profile.d/go.sh
        cat /etc/profile.d/go.sh >> "$HOME/.bashrc"

        # clean up
        rm -f go1.25.0.linux-amd64.tar.gz
        else
            echo "go was found"
    fi 

    ## SDKMAN  
    if ! command -v sdkman version >/dev/null 2>&1
    then
    	curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        echo "sdkman was found"
    fi

    source $HOME/.bashrc

    # VS Code extensions 
    #curl -fsSL https://raw.githubusercontent.com/andregcaires/setup/refs/heads/master/vscode-setup.sh | bash 
}

install_flatpak() {
    if ! command -v flatpak --version >/dev/null 2>&1
    then
        echo "flatpak not found, must install and reboot afterwards"
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    else
        echo "flatpak already installed"
    fi
}

install_flatpak_apps() {

    flatpak install com.spotify.Client com.getpostman.Postman com.opera.Opera com.microsoft.Edge org.chromium.Chromium org.libreoffice.LibreOffice -y
}

show_title() {
    echo " __     __   ____ _  _ "
    echo "(  )   /__\ (_   | \/ )"
    echo " )(__ /(__)\ / /_ \  / "
    echo "(____|__)(__|____)(__) "
    echo 
}

show_menu() {
    echo -e "Linux software setup for any lazy-ass individual"
    echo -e "Use the -h flag to view the options"
}

show_help() {
    echo "Use: source setup.sh [options]"
    echo
    echo "Available options:"
    echo "  -a | --all          Install both external and package manager software (same as -b -e)"
    echo "  -b | --basic        Install software in the current package manager"
    echo "                          Currently supported package managers: apt, pacman"
    echo "  -e | --external     Install external packages (FNM, SDKMAN, Rustup, Go)"
    echo "  -f | --flatpak      Install Flatpak and some Flatpaks"
    echo "  -p | --ppa          Install external packages through PPAs"
    echo "  -h | --help         Show help menu (you're here)"
    echo
}

show_title

if [ $# -eq 0 ]
then
    show_menu
# elif [ "$#" -gt 1 ]; then
#     echo "Please use only one option"
#     show_help
else
    for arg in "$@"; do
        case $arg in
            -a|--all)
                install_os_specific_apps
                install_external_tools
            ;;
            -h|--help)
                show_help
            ;;
            -b|--basic)
                install_os_specific_apps
            ;;
            -f|--flatpak)
                install_flatpak
                install_flatpak_apps
            ;;
            -e|--external)
                install_external_tools
            ;;
            -p|--ppa)
                install_through_ppas
            ;;
            *)
                echo "Invalid argument: $arg"
            ;;
        esac
    done
fi

