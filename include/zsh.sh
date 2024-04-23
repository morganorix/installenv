#!/bin/bash

zsh() {
    title "ZSH"
    sub-title "INSTALLATION"
    installpkg "zsh"

    local options=(
        'Oh-my-zsh' 'Plugin: Installation du thème pour le terminal' on
        'Highlight' 'Plugin: oh-my-zsh' on
    )

    local selected=$(window "$options" "Installation des plugins pour ZSH")

    for choice in $selected; do
        case $choice in
            "Oh-my-zsh") ohmyzsh ;;
            "Highlight") highlight ;;
        esac
    done
}

ohmyzsh() {
    sub-title "OH-MY-ZSH" "Installation plugin Oh-my-zsh"
    text "installation en cours..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>/dev/null

    [ ! "$?" -ne 0 ] && text "Success" "Oh-my-zsh est installé" || text "Error" "Impossible d'installer Oh-my-zsh."
}

highlight() {
    sub-title "HIGHLIGHT" "Installation plugin Highlight pour Oh-my-zsh"
    text "installation en cours..."
    pretty git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 

    if [[ $? -eq 0 ]]; then
        echo "source ${PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>${ZDOTDIR:-$HOME}/.zshrc
        text "Info" "Faire un  : \"source .zshrc\""
    fi
}