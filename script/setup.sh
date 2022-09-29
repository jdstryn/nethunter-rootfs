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
    echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
    termux-setup-storage
    if [[ `command -v pulseaudio` && `command -v proot-distro` && `command -v wget` ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Packages already installed."${W}
    else
        packs=(pulseaudio proot-distro wget)
        for hulu in "${packs[@]}"; do
            type -p "$hulu" &>/dev/null || {
                echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
                apt update -y
                apt upgrade -y
                apt install "$hulu" -y
            }
        done
    fi
}

script() {
    termux-reload-settings
    echo -e "\n${R} [${W}-${R}]${G} Downloading Installer Script..."${W}
    wget https://raw.githubusercontent.com/jdstryn/modded-nethunter/master/distro-plugins/nethunter.sh
    mv -f nethunter.sh $PREFIX/etc/proot-distro/nethunter.sh
    chmod +x $PREFIX/etc/proot-distro/*.sh
    termux-reload-settings
}

distro() {
    echo -e "\n${R} [${W}-${R}]${C} Checking for Distro..."${W}
    termux-reload-settings
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/nethunter" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Distro already installed."${W}
        exit 0
    else
        proot-distro install nethunter
        termux-reload-settings
    fi
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/nethunter" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Installed Successfully !!"${W}
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !\n"${W}
        exit 0
    fi
}

sound() {
    echo -e "\n${R} [${W}-${R}]${C} Fixing Sound Problem..."${W}
    if [[ ! -e "$HOME/.sound" ]]; then
        touch $HOME/.sound
    fi
    echo "pulseaudio --start --exit-idle-time=-1" >> $HOME/.sound
    echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> $HOME/.sound
}

permission() {
    banner
    echo -e "${R} [${W}-${R}]${C} Setting up Environment..."${W}
    if [[ -e "$PREFIX/var/lib/proot-distro/installed-rootfs/nethunter/root/user.sh" ]]; then
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/nethunter/root/user.sh
    else
        wget https://raw.githubusercontent.com/jdstryn/modded-nethunter/master/script/user.sh
        mv -f user.sh $PREFIX/var/lib/proot-distro/installed-rootfs/nethunter/root/user.sh
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/nethunter/root/user.sh
    fi
    echo "proot-distro login nethunter --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > $PREFIX/bin/nethunter
    if [[ -e "$PREFIX/bin/nethunter" ]]; then
        chmod +x $PREFIX/bin/nethunter
        termux-reload-settings
        banner
        echo -e "\n${R} [${W}-${R}]${G} nethunter(CLI) is now Installed on your Termux"${W}
        echo -e "\n${R} [${W}-${R}]${G} Type ${C}nethunter${G} to run nethunter CLI."${W}
        echo -e "\n${R} [${W}-${R}]${G} If you Want to Use nethunter with youre user then,"${W}
        echo -e "\n${R} [${W}-${R}]${G} Run ${C}nethunter${G} first & then type ${C}bash user.sh "${W}
        echo -e "\n"
        exit 0
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !"${W}
        exit 0
        fi
}

banner
package
script
distro
sound
permission
