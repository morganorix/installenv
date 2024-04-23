#!/bin/bash

samba() {
    cmd=(dialog --output-fd 1 --keep-tite --backtitle "Dialog Form Example" --title "Samba configuration" \
        --form "Dialog Sample Label and Values" 25 60 16 \
        "Hostname:" 1 1 "" 1 25 25 30 \
        "Login:"    2 1 "" 2 25 25 30 \
        "Password:" 3 1 "" 3 25 25 30
        )
    local selected=$("${cmd[@]}")

    local i=0;
    for choice in $selected; do
        [ "$i" -eq 0 ] && local hostname="$choice"
        [ "$i" -eq 1 ] && local login="$choice" || local pwd="$choice"
        i+=1
    done

    title "SAMBA"
    sub-title "INSTALLATION & CONFIGURATION"
    installpkg "samba"

    cat 2>/dev/null > ${PWD}/.smbcreds <<EOF
username=${login}
password=${pwd}
EOF
    [ ! "$?" -ne 0 ] && text "Info" "Le fichier .smbcreds est créé et configuré" || text "Error" "Impossible de configurer le fichier .smbcreds"
    
    text "Info" "Mise en place des permissions pour le fichier .smbcreds"
    pretty chown $(whoami):$(whoami) ${PWD}/.smbcreds 2>/dev/null
    [ ! "$?" -ne 0 ] && text "Info" "Persmissions effectué avec success." || text "Error" "Impossible de mettre les permissions en place."
    
    pretty mkdir ${PWD}/BACKUP 
    sudo sh -c "cat 2>/dev/null << EOF >> /etc/fstab
//${hostname}/BACKUP ${PWD}/BACKUP cifs _netdev,vers=3.0,users,noauto,credentials=${PWD}/.smbcreds 0 0
    "
    [ ! "$?" -ne 0 ] && text "Info" "Le fichier /etc/fstab a été modifié" || text "Error" "Impossible de modifier le fichier /etc/fstab"
    pretty mount ${PWD}/BACKUP
}
