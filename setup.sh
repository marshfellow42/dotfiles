#!/bin/bash

sudo pacman -Syu git fastfetch hyprcursor hyprpicker hyprlock hypridle hyprshot rofi-wayland swww waybar swaync cliphist flatpak figlet btop cronie

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../

yay -Syu oh-my-posh-bin

git clone --depth=1 https://github.com/marshfellow42/wallpapers.git

mv ./.bashrc ~/
mv ./.gitconfig ~/
mv ./update_all.sh ~/

mv ./swww_morning.sh ~/
mv ./swww_afternoon.sh ~/
mv ./swww_night.sh ~/

source ~/.bashrc

echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."
sleep 10
reboot
