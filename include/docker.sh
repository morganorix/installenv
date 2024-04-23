#!/bin/bash

docker() {
    title "DOCKER"
    sub-title "INSTALLATION DOCKER" "Téléchargement et installation des certificats et des packages"

    text "Info" "Téléchargement et installation de docker cli"
    installpkg "ca-certificates"
    installpkg "curl"

    pretty sudo install -m 0755 -d /etc/apt/keyrings
    pretty sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    pretty sudo chmod a+r /etc/apt/keyrings/docker.asc

    text "Info" "Enregistrement de la source pour télécharger Docker"
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    
    pretty sudo tee /etc/apt/sources.list.d/docker.list 
    pretty sudo apt-get update
    
    text "Info" "Téléchargement et installation de docker cli"
    selected=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
    for choice in $selected; do
        installpkg "$choice"
    done

    pretty sudo usermod -aG docker $(whoami) 
    newgrp docker
}
