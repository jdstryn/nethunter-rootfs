#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner() {
    clear
    printf "\033[0m\n"
    printf "     \033[32mA modded version of nethunter for Termux\033[0m\n"
    printf "\033[0m\n"
}

package() {
    echo -e "${R} [${W}-${R}]${C} Purging packages..."${W}
    termux-reload-settings
    proot-distro remove nethunter && proot-distro clear-cache
    rm -rf $PREFIX/bin/nethunter
    rm -rf $PREFIX/etc/proot-distro/nethunter.sh
    sed -i 's/pulseaudio/#pulseaudio/g' ~/.sound
    sed -i 's/pacmd/#pacmd/g' ~/.sound
    termux-reload-settings
    echo -e "${R} [${W}-${R}]${C} Purging Completed !"${W}
}

banner
package
