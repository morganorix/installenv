#!/bin/bash

# Define ANSI color and style codes
Red='\033[0;31m'
Gray='\033[0;90m'   
Green='\033[0;32m'
Yellow='\033[0;33m'
Orange='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
Bold='\033[1m'
Italic='\e[3m'
Underline='\033[4m'

title() {
    local message="$1"
    local len=$((${#message}+2))
    printf "\n+"
    printf -- "-%.0s" $(seq 1 $len)
    # shellcheck disable=SC2059
    printf "+\n| $(print_colored_text Yellow Bold "$message") |\n+"
    printf -- "-%.0s" $(seq 1 $len)
    printf "+\n"
}

sub-title() {
    local message="$1"
    local len=$((${#message}+2))
    tiret=`printf -- "-%.0s" $(seq 1 $len)`
    printf '\e[36;1m%-10s |\033[0;90m %s\n' "Info" "$tiret"
    printf "\e[36;1m%-10s |  %s\n" "Info" "$1"
    printf '\e[36;1m%-10s |\033[0;90m %s\n' "Info" "$tiret"
    if [ -n "$2" ]; then
        printf '\e[36;1m%-10s |\033[0;90m %s\n' "Info" "Description : "
        printf '\e[36;1m%-10s |\033[0;90m %s \n' "Info" "$2"
        printf '\e[36;1m%-10s |\033[0;90m %s\n' "Info" ""
    fi
}


text() {
    case $1 in
        "Sucess")
            printf "\e[32;1m%-10s | %s\n" "$1" "$2"
            ;;
        "Error")
            printf "\e[31;1m%-10s | %s\n" "$1" "$2"
            ;;
        "Info")
            printf "\e[36;1m%-10s |\033[0;90m %s\n" "$1" "$2"
            ;;
    esac
}
