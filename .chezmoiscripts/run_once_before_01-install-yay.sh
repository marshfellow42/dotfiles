#!/usr/bin/env bash

OS="$(uname -s)"

case "$OS" in
    Linux)
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                arch)
                    if ! command -v yay &> /dev/null; then
                        sudo pacman -S --needed --noconfirm git base-devel
                        git clone https://aur.archlinux.org/yay.git ~/yay
                        cd ~/yay
                        makepkg -si --noconfirm
                        # --gendb is used to generate a development package database for *-git packages that were installed without yay
                        yay -Y --gendb
                        # --devel --save is used to make development package updates permanently enabled (yay and yay -Syu will then always check dev packages)
                        yay -Y --devel --save
                        cd ..
                        rm -rf yay
                    else
                        echo "yay already found, skipping."
                    fi
                    ;;
                *)
                    echo "Unsupported Linux distribution: $ID"
                    exit 1
                    ;;
            esac
        else
            echo "Cannot detect Linux distribution"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac