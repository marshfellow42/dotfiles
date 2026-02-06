#!/usr/bin/env bash

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