#!/bin/bash

samba() {
    title "SAMBA"
    sub-title "INSTALLATION & CONFIGURATION"
    installpkg "samba"

    cat 2>/dev/null > ${PWD}/.smbcreds <<"EOF"
username=<username>
password=<pwd>
EOF
    [ ! "$?" -ne 0 ] && text "Info" "Le fichier .smbcreds est créé et configuré" || text "Error" "Impossible de configurer le fichier .smbcreds"
    
    text "Info" "Mise en place des permissions pour le fichier .smbcreds"
    pretty chown <user>:<group> ${PWD}/.smbcreds 2>/dev/null
    [ ! "$?" -ne 0 ] && text "Info" "Persmissions effectué avec success." || text "Error" "Impossible de mettre les permissions en place."
    
    pretty mkdir ${PWD}/BACKUP 
    sudo sh -c "cat 2>/dev/null << EOF >> /etc/fstab
//<IP ADDRESS>/BACKUP ${PWD}/BACKUP cifs _netdev,vers=3.0,users,noauto,credentials=${PWD}/.smbcreds 0 0
    "
    [ ! "$?" -ne 0 ] && text "Info" "Le fichier /etc/fstab a été modifié" || text "Error" "Impossible de modifier le fichier /etc/fstab"
    pretty mount ${PWD}/BACKUP
}
