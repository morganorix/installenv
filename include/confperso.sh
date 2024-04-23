#!/bin/bash

confperso() {
    sub-title "CRÉATION DU FICHIER" "${PWD}/.bash"
#==============================================================
# .bash
#==============================================================
    text "Info" "Création du fichier .bash..."

    # Test docker installé
    [ ! $(command -v docker) ] && local docker="" || local docker=$(which docker)
    
    # Test suivant la version 
    [ ! $(command -v bat) ] && local bat=$(which batcat) || local bat=$(which bat)

    cat 2>/dev/null > ${PWD}/.bash <<EOF
# LS amélioré
alias ls="exa --long -g"
# CAT amélioré
alias cat="${bat} --paging=never --map-syntax=\"*.conf:nginx\" -l C++"
# TAIL amélioré
tailpimpe() {
        tail -f "$1" | ${bat} --paging=never -l log;
}
alias log="tailpimpe"
EOF

    if [ -n $docker ]; then
        text "Info" "Création du fichier de configuration docker"
        [ -d "${PWD}/.docker/" ] && pretty rm -rf .docker
        pretty mkdir .docker

    cat 2>/dev/null > ${PWD}/.docker/config.json <<"EOF"
{
    "psFormat": "table {{.ID}}\\t|     {{.Names}}\\t|     {{.Image}}\\t|     {{.RunningFor}}\\t|     {{.Status}}",
    "inspectFormat": "table {{.ID}}\\t|     {{.Names}}\\t|     {{.Image}}\\t|     {{.RunningFor}}\\t|     {{.Status}}",
    "imagesFormat": "table {{.Repository}}\\t|\\t{{.Tag}}\\t|\\t{{.ID}}\\t|\\t{{.Size}}"
}
EOF
    [ ! "$?" -ne 0 ] && text "Info" "Le fichier ${PWD}/.docker/config.json est créé et configuré" || text "Error" "Impossible de configurer le fichier ${PWD}/.docker/config.json"

        cat 2>/dev/null << EOF >> ${PWD}/.bash
alias dc="docker compose"
alias dcps="docker ps -a | ${bat} --paging=never -l 'C++'"
alias dcip="${PWD}/.scripts/docker/dockerip.sh"
EOF

        [ ! "$?" -ne 0 ] && text "Info" "Le fichier .bash est créé et configuré" || text "Error" "Impossible de configurer le fichier .bash"
    fi

    if [ ! -d "${PWD}/.scripts/" ]; then
        pretty mkdir ${PWD}/.scripts
        pretty mkdir ${PWD}/.scripts/docker
    else
        [ ! -d "${PWD}/.scripts/docker" ] && pretty mkdir ${PWD}/.scripts/docker
    fi

    if [ ! $(command -v bat) ]; then
        cat 2>/dev/null > ${PWD}/.scripts/docker/dockerip.sh <<"EOF"
#!/bin/bash
docker inspect $(docker ps -a -q) --format "{{title .Name}} | {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}} | {{json .Config.ExposedPorts}}" | column -t -s ' ' | batcat --paging=never -l 'C++'
EOF
        [ ! "$?" -ne 0 ] && text "Info" "Le fichier dockerip.sh est créé et configuré" || text "Error" "Impossible de configurer le fichier dockerip.sh"
    else
        cat 2>/dev/null > ${PWD}/.scripts/docker/dockerip.sh <<"EOF"
#!/bin/bash
docker inspect $(docker ps -a -q) --format "{{title .Name}} | {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}} | {{json .Config.ExposedPorts}}" | column -t -s ' ' | bat --paging=never -l 'C++'
EOF
        [ ! "$?" -ne 0 ] && text "Info" "Le fichier dockerip.sh est créé et configuré" || text "Error" "Impossible de configurer le fichier dockerip.sh"
    fi

    pretty chmod +x ${PWD}/.scripts/docker/dockerip.sh

    echo "source ${PWD}/.bash" >>${ZDOTDIR:-$HOME}/.zshrc
    text "Info" "Faire un  : \"source .zshrc\""
}
