#!/bin/bash

sudo pacman -Syu git fastfetch hyprcursor hyprpicker hyprlock hypridle hyprshot rofi-wayland swww waybar swaync cliphist flatpak figlet

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../

yay -Syu oh-my-posh

git clone https://github.com/marshfellow42/wallpapers.git

git clone https://github.com/marshfellow42/dotfiles.git

cd dotfiles
mv .bashrc ~/

source ~/.bashrc

echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."
sleep 10
reboot
