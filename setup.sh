#!/bin/bash


package_list=("sudo" "curl" "git" "firefox" "zip" "unzip")

install_via_apt() {
    echo "installing via apt"

	sudo apt update
    for package in ${package_list[@]}; do
        sudo apt install $package -y
    done
    
    ## vscode
    if ! command -v code >/dev/null 2>&1
    then
        sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        rm -f packages.microsoft.gpg
        sudo apt install apt-transport-https -y
        sudo apt update
        sudo apt install code -y
    else
        echo "vscode was found"
    fi

}

install_via_pacman() {
    # TODO add more packages 
    echo "installing via pacman"
    for package in ${package_list[@]}; do
        pacman -S $package
    done
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
    echo "  -a | --all          Install both external and package manager software"
    echo "  -p | --package      Install software in the current package manager"
    echo "                          Currently supported package managers: apt, pacman"
    echo "  -e | --external     Install external packages"
    echo "  -h | --help         Show help menu (you're here)"
    echo
}

show_title

if [ $# -eq 0 ]
then
    show_menu
elif [ "$#" -gt 1 ]; then
    echo "Please use only one option"
    show_help
else
    for arg in "$@"; do
        case $arg in
            -a|--all)
            install_os_specific_apps
            install_through_online_scripts
            ;;
            -h|--help)
            show_help
            ;;
            -p|--package)
            install_os_specific_apps
            ;;
            -e|--external)
            install_through_online_scripts
            ;;
            *)
            echo "Invalid argument: $arg"
            ;;
        esac
    done
fi

