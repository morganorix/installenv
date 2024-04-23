#!/bin/bash

INCLUDE="${PWD}/.scripts/env/include"

source "$INCLUDE/colors.sh"
source "$INCLUDE/pretty.sh"
source "$INCLUDE/zsh.sh"
source "$INCLUDE/motd.sh"
source "$INCLUDE/samba.sh"
source "$INCLUDE/docker.sh"
source "$INCLUDE/dialog.sh"
source "$INCLUDE/confperso.sh"
source "$INCLUDE/functions.sh"

title "UPDATE ET UPGRADE DU SYSTÈME"

sub-title "MISE À JOUR EN COURS..."
pretty sudo apt update -y && printf '\e[32;1m%-10s | %s\n\e[0m' "Sucess" "Mise à jour éffectuée avec succès." || printf '\e[31;1m%-10s | %s\n\e[0m' "Error" "La mise à jour c'est mal passée."
printf '\n'

sub-title "MISE À NIVEAU EN COURS..."
pretty sudo apt upgrade -y && printf '\e[32;1m%-10s | %s\n\e[0m' "Sucess" "Mise à niveau éffectuée avec succès." || printf '\e[31;1m%-10s | %s\n\e[0m' "Error" "La mise à niveau c'est mal passée."

title "PRÉ-REQUIS"

sub-title "INSTALLATION DES PRÉ-REQUIS...." "Installation des packages dialog & git"
pretty sudo apt-get install -y dialog git && printf '\e[32;1m%-10s | %s\n\033[0;90m\n' "Sucess" "Pré-requis installés avec succès." || printf '\e[31;1m%-10s | %s\n\e[0m' "Error" "La mise à jour c'est mal passée."

sub-title "CONFIGURATION DES PRÉ-REQUIS" "Création d'un fichier .dialogrc dans ${PWD}"
dialogconf

main
exit 0
