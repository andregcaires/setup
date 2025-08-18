#!/bin/bash

install_common_extensions() {
    CURRENT_EDITOR=$1
    extension_list=(
        eamodio.gitlens
        quicktype.quicktype
        ms-vscode-remote.remote-containers
    )
    if [ $# -eq 1 ]; then
        echo "Instaling common extensions for the Default profile"
        for extension in "${extension_list[@]}"; do
            $CURRENT_EDITOR --install-extension $extension
        done
    else 
        echo "Instaling common extensions for the $2 profile"
        for extension in "${extension_list[@]}"; do
            $CURRENT_EDITOR --install-extension $extension --profile $2
        done
    fi
}

# Java / Spring 
install_java_extensions() {
    CURRENT_EDITOR=$1
    CURRENT_PROFILE=Java
    extension_list=(
        "vscjava.vscode-java-pack" 
        "vmware.vscode-boot-dev-pack" 
        "visualstudioexptteam.vscodeintellicode"
    )
    
    echo "Instaling ${CURRENT_PROFILE} extensions"
    $CURRENT_EDITOR --profile $CURRENT_PROFILE
    for extension in "${extension_list[@]}"; do
        $CURRENT_EDITOR --install-extension $extension --profile $CURRENT_PROFILE
    done

    install_common_extensions $CURRENT_EDITOR $CURRENT_PROFILE
}

# Python
install_python_extensions() {
    CURRENT_EDITOR=$1
    CURRENT_PROFILE=Python
    extension_list=(
        "visualstudioexptteam.vscodeintellicode-completions" 
        "ms-python.python" 
        "ms-python.debugpy" 
        "ms-python.vscode-pylance" 
        "visualstudioexptteam.vscodeintellicode"
    )
    
    echo "Instaling ${CURRENT_PROFILE} extensions"
    $CURRENT_EDITOR --profile $CURRENT_PROFILE
    for extension in "${extension_list[@]}"; do
        $CURRENT_EDITOR --install-extension $extension --profile $CURRENT_PROFILE
    done

    install_common_extensions $CURRENT_EDITOR $CURRENT_PROFILE
}

# Rust
install_rust_extensions() {
    CURRENT_EDITOR=$1
    CURRENT_PROFILE=Rust
    extension_list=(
        "rust-lang.rust-analyzer"
    )

    echo "Instaling ${CURRENT_PROFILE} extensions"
    $CURRENT_EDITOR --profile $CURRENT_PROFILE
    for extension in "${extension_list[@]}"; do
        $CURRENT_EDITOR --install-extension $extension --profile $CURRENT_PROFILE
    done

    install_common_extensions $CURRENT_EDITOR $CURRENT_PROFILE
}

# Go
install_go_extensions() {
    CURRENT_EDITOR=$1
    CURRENT_PROFILE=Go
    extension_list=(
        "golang.go"
        "tooltitudeteam.tooltitude"
        "premparihar.gotestexplorer"
    )
    
    echo "Instaling ${CURRENT_PROFILE} extensions"
    $CURRENT_EDITOR --profile $CURRENT_PROFILE
    for extension in "${extension_list[@]}"; do
        $CURRENT_EDITOR --install-extension $extension --profile $CURRENT_PROFILE
    done

    install_common_extensions $CURRENT_EDITOR $CURRENT_PROFILE
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
    echo "  -r | --rust         Install Rust profile extensions"
    echo "  -g | --go           Install Go profile extensions"
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
    EDITORS=("codium" "code")
    for EDITOR_BIN in "${EDITORS[@]}"; do
        if command -v "$EDITOR_BIN" &> /dev/null; then
            echo "Installing extensions for $EDITOR_BIN"
                for arg in "$@"; do
                    case $arg in
                        -a|--all)
                        install_common_extensions $EDITOR_BIN
                        install_java_extensions $EDITOR_BIN
                        install_python_extensions $EDITOR_BIN
                        install_rust_extensions $EDITOR_BIN
                        install_go_extensions $EDITOR_BIN
                        ;;
                        -h|--help)
                        show_help
                        ;;
                        -d|--default)
                        install_common_extensions $EDITOR_BIN
                        ;;
                        -p|--python)
                        install_python_extensions $EDITOR_BIN
                        ;;
                        -j|--java)
                        install_java_extensions $EDITOR_BIN
                        ;;
                        -r|--rust)
                        install_rust_extensions $EDITOR_BIN
                        ;;
                        -g|--go)
                        install_go_extensions $EDITOR_BIN
                        ;;
                        *)
                        echo "Invalid argument: $arg"
                        ;;
                    esac
                done
        else
            echo "$EDITOR_BIN not found"
        fi
    done


fi
