#!/bin/bash

code --install-extension pomdtr.excalidraw-editor
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension figma.figma-vscode-extension
code --install-extension alefragnani.project-manager

# Java / Spring 
install_java_extensions() {
    code --profile Java
    extension_list=("vscjava.vscode-java-pack" "vmware.vscode-boot-dev-pack" "eamodio.gitlens" "ms-vscode-remote.vscode-remote-extensionpack" "visualstudioexptteam.vscodeintellicode")
    for extension in ${extension_list[@]}; do
        code --install-extension $extension --profile Java
    done
}

# Python
install_python_extensions() {
    code --profile Python
    extension_list=("ms-vscode-remote.vscode-remote-extensionpack" "visualstudioexptteam.vscodeintellicode-completions" "ms-python.python" "ms-python.debugpy" "ms-python.vscode-pylance" "visualstudioexptteam.vscodeintellicode" "eamodio.gitlens")
    for extension in ${extension_list[@]}; do
        code --install-extension $extension --profile Python
    done
}

if ! command -v code --version >/dev/null 2>&1
then
    echo "vscode was not found"
else
    install_java_extensions
    install_python_extensions
fi

