#!/bin/bash

motd() {
    title "CONFIGURATION DU MOTD DYNAMIQUE"
    
    sub-title "INSTALLATION..." "Installation des packages figlet & lsb-release"

    installpkg "figlet"
    installpkg "lsb-release"

    text "Info" "Suppresion des fichiers existant dans /etc/update-motd.d/"
    pretty sudo rm -rf /etc/update-motd.d/* && text "Info" "Les fichiers sont supprimés." || text "Error" "Impossible de supprimer les fichiers"

    sub-title "CRÉATION DES FICHIERS" "00-hostname | 10-banner | 20-sysinfo"

#==============================================================
# 00-hostname
#==============================================================
    text "Info" "Création du fichier 00-hostname..."
    sudo bash -c 'cat 2>/dev/null > /etc/update-motd.d/00-hostname <<"EOF"
#!/bin/sh

NONE="\033[m"
LIGHT_RED="\033[1;31m"

printf "\n"$LIGHT_RED
figlet "  "$(hostname -s)
printf $NONE
printf "\n"
EOF' 

    [ ! "$?" -ne 0 ] && text "Info" "Le fichier 00-hostname est créé et configuré" || text "Error" "Impossible de configurer le fichier 00-hostname"

#==============================================================
# 10-banner
#==============================================================
    text "Info" "Création du fichier 10-banner..."
    sudo bash -c 'cat 2>/dev/null > /etc/update-motd.d/10-banner <<"EOF"
#!/bin/bash

NONE="\033[m"
YELLOW="\033[1;33m"

[ -r /etc/update-motd.d/lsb-release ] && . /etc/update-motd.d/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
    # Fall back to using the very slow lsb_release utility
    DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

re='"'"'(.*\()(.*)(\).*)'"'"'
if [[ $DISTRIB_DESCRIPTION =~ $re ]]; then
    DISTRIB_DESCRIPTION=$(printf "%s%s%s%s%s" "${BASH_REMATCH[1]}" "${YELLOW}" "${BASH_REMATCH[2]}" "${NONE}" "${BASH_REMATCH[3]}")
fi

echo -e "  "$DISTRIB_DESCRIPTION "(kernel "$(uname -r)")\n"

# Update the information for next time
printf "DISTRIB_DESCRIPTION=\"%s\"" "$(lsb_release -s -d)" > /etc/update-motd.d/lsb-release &
EOF' 

    [ ! "$?" -ne 0 ] && text "Info" "Le fichier 10-banner est créé et configuré" || text "Error" "Impossible de configurer le fichier 10-banner"

#==============================================================
# 20-sysinfo
#==============================================================
    text "Info" "Création du fichier 20-sysinfo..."
    sudo bash -c 'cat 2>/dev/null > /etc/update-motd.d/20-sysinfo <<"EOF"
#!/bin/sh

proc=`(echo $(more /proc/cpuinfo | grep processor | wc -l ) "x" $(more /proc/cpuinfo | grep '"'"'model name'"'"' | uniq |awk -F":"  '"'"'{print $2}'"'"') )`
memfree=`cat /proc/meminfo | grep MemFree | awk {'"'"'print $2'"'"'}`
memtotal=`cat /proc/meminfo | grep MemTotal | awk {'"'"'print $2'"'"'}`
uptime=`uptime -p`
addrip=`hostname -I | cut -d " " -f1`
# Récupérer le loadavg
read one five fifteen rest < /proc/loadavg

# Affichage des variables
printf "  Processeur : $proc\n"
printf "  Charge CPU : $one (1min) / $five (5min) / $fifteen (15min)\n"
printf "  Adresse IP : $addrip\n"
printf "  RAM : $(($memfree/1024))MB libres / $(($memtotal/1024))MB\n"
printf "  Uptime : $uptime\n\n"
EOF' 

    [ ! "$?" -ne 0 ] && text "Info" "Le fichier 20-sysinfo est créé et configuré" || text "Error" "Impossible de configurer le fichier 20-sysinfo"

    sub-title "CONFIGURATION" "Activation du motd"

    pretty sudo rm /etc/motd && text "Info" "Suppression du lien symbolique existant." || text "Error" "Impossible de supprimer le lien symbolique."

    pretty sudo chmod 0740 /etc/update-motd.d/* && text "Info" "Changement de droit des fichiers /etc/update-motd.d/" || text "Error" "Impossible de changer les droits des fichiers /etc/update-motd.d/"
    
    pretty sudo ln -s /var/run/motd.dynamic /etc/motd && text "Info" "Lien symbolique créé." || text "Error" "Impossible de créé le lien symbolique."

    sub-title "VISUALISATION DU MOTD"
    sudo run-parts /etc/update-motd.d/
}