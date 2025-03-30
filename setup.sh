#!/bin/bash

sudo pacman -Syu --needed fastfetch hyprcursor hyprlock hypridle rofi-wayland swww waybar swaync cliphist flatpak cronie

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../

yay -Syu oh-my-posh-bin hyprshot --noconfirm

git clone --branch timeofday --depth=1 https://github.com/marshfellow42/wallpapers.git

mv ./wallpapers ~/
mv ./cron ~/

cp -r ./.config/* ~/.config/
mv -f ./.bashrc ~/
mv -f ./.gitconfig ~/
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
