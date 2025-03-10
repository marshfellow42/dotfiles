#!/bin/bash

sudo pacman -Syu git fastfetch hyprcursor hyprpicker hyprlock hypridle hyprshot rofi-wayland swww waybar swaync cliphist flatpak figlet btop cronie

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../

yay -Syu oh-my-posh-bin

git clone --branch timeofday --depth=1 https://github.com/marshfellow42/wallpapers.git

mv ./wallpapers ~/
mv ./cron ~/

mv ./.config ~/
mv ./.bashrc ~/
mv ./.gitconfig ~/
mv ./update_all.sh ~/

source ~/.bashrc

prompt_user() {
  local prompt_message=$1
  read -p "$prompt_message [Y/N] " choice
  echo "$choice"
}

apps_choice=$(prompt_user "Do you wish to download all the apps?")

if [[ $apps_choice =~ ^[Yy]*$ ]] || [[ -z $apps_choice ]]; then
  ./install/install.sh
fi

(cat cronjob.txt; crontab -l) | crontab -

echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."
sleep 10
reboot
