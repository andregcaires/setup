#!/bin/bash

install_common_extensions() {
    extension_list=(
        pomdtr.excalidraw-editor 
        ms-vscode-remote.vscode-remote-extensionpack 
        figma.figma-vscode-extension 
        alefragnani.project-manager 
        eamodio.gitlens
    )
    if [ $# -eq 0 ]; then
        echo "Instaling common extensions for the Default profile"
        for extension in "${extension_list[@]}"; do
            code --install-extension $extension
        done
    else 
        echo "Instaling common extensions for the $1 profile"
        for extension in "${extension_list[@]}"; do
            code --install-extension $extension --profile $1
        done
    fi
}

# Java / Spring 
install_java_extensions() {
    CURRENT_PROFILE=Java
    code --profile $CURRENT_PROFILE
    
    echo "Instaling ${CURRENT_PROFILE} extensions"
    extension_list=(
        "vscjava.vscode-java-pack" 
        "vmware.vscode-boot-dev-pack" 
        "visualstudioexptteam.vscodeintellicode"
    )
    for extension in "${extension_list[@]}"; do
        code --install-extension $extension --profile $CURRENT_PROFILE
    done

    install_common_extensions $CURRENT_PROFILE
}

# Python
install_python_extensions() {
    CURRENT_PROFILE=Python
    code --profile $CURRENT_PROFILE
    
    echo "Instaling ${CURRENT_PROFILE} extensions"
    extension_list=(
        "visualstudioexptteam.vscodeintellicode-completions" 
        "ms-python.python" 
        "ms-python.debugpy" 
        "ms-python.vscode-pylance" 
        "visualstudioexptteam.vscodeintellicode"
    )
    for extension in "${extension_list[@]}"; do
        code --install-extension $extension --profile $CURRENT_PROFILE
    done

    install_common_extensions $CURRENT_PROFILE
}

show_help() {
    echo "Use: source vscode-setup.sh [options]"
    echo
    echo "Available options:"
    echo "  -a | --all          Install all profile extensions"
    echo "  -h | --help         Show help menu (you're here)"
    echo "  -d | --default      Install common extensions in the Default profile"
    echo "  -p | --python       Install Python profile extensions"
    echo "  -j | --java         Install Java profile extensions"
    echo
}

show_menu() {
    echo -e "Linux software setup for any lazy-ass individual"
    echo -e "Use the -h flag to view the options"
}

show_title() {
    echo " __     __   ____ _  _ "
    echo "(  )   /__\ (_   | \/ )"
    echo " )(__ /(__)\ / /_ \  / "
    echo "(____|__)(__|____)(__) "
    echo 
}

show_title

if [ $# -eq 0 ]
then
    show_menu
else
    for arg in "$@"; do
        case $arg in
            -a|--all)
            install_common_extensions
            install_java_extensions
            install_python_extensions
            ;;
            -h|--help)
            show_help
            ;;
            -d|--default)
            install_common_extensions
            ;;
            -p|--python)
            install_python_extensions
            ;;
            -j|--java)
            install_java_extensions
            ;;
            *)
            echo "Invalid argument: $arg"
            ;;
        esac
    done
fi
