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
        echo "Instaling common extensions"
        for extension in "${extension_list[@]}"; do
            code --install-extension $extension
        done
    else 
        echo "Instaling common extensions for $1 profile"
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

if ! command -v code >/dev/null 2>&1
then
    echo "vscode was not found"
else
    install_common_extensions
    install_java_extensions
    install_python_extensions
fi

