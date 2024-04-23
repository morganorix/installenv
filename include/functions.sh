#!/bin/bash

window() {
    cmd=(dialog --output-fd 1 --keep-tite --separate-output --extra-button --extra-label 'Select All' --cancel-label 'Select None' --checklist "$2:" 0 0 0)
    local choices=$("${cmd[@]}" "${options[@]}")

    echo "${choices[@]}"
    exit $?
}

start() {
    local options=(
        'nano' 'Editeur de fichier' off
        'samba' 'Partage de dossiers' on
        'exa' 'Command ls plus classe' on
        'bat' 'bat Command cat en plus classe' on
        'motd' 'Motd dynamique pour un affichage plus classe' on
        'docker' 'Install docker cli (debian)' off
        'Conf' 'Fichier .bash avec ses alias' on
        'zsh' 'The Z shell' on
    )

    echo "$(window \"$options\" \"Installation environnement\")"
}

installpkg() {
    sub-title "$1" "Installation de $1"
    pretty sudo apt-get install -y "$1"
}

main() {
    selected=$(start)

    title "PACKAGES"
    for choice in $selected; do
        case $choice in
        "motd") motd ;;
        "zsh") zsh ;;
        "samba") samba ;;
        "docker") docker ;;
        "Conf") confperso ;;
        *) installpkg "$choice" ;;
        esac
    done
}
