#!/bin/bash

sudo pacman -Syu --needed fastfetch hyprcursor hyprlock hypridle rofi-wayland swww waybar swaync cliphist flatpak cronie mpv featherpad ttf-jetbrains-mono-nerd archlinux-xdg-menu python-pywal16 kde-cli-tools

if kbuildsycoca6 --noincremental 2>&1 | grep -q '"applications.menu" not found in QList'; then
  sudo update-desktop-database
  cd /etc/xdg/menus || exit
  sudo mv arch-applications.menu applications.menu
  kbuildsycoca6 --noincremental
fi

cd ~/

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../

cd dotfiles/

flatpak install -y flathub org.kde.gwenview org.kde.kcalc

yay -Syu hyprshot librewolf-bin --noconfirm

git clone --branch timeofday --depth=1 https://github.com/marshfellow42/wallpapers.git

mv ./wallpapers ~/
mv ./cron ~/

cp -r ./.config/* ~/.config/
mv -f ./.bashrc ~/
mv -f ./.gitconfig ~/
mv ./update_all.sh ~/

mkdir -p ~/Pictures/Screenshots/

source ~/.bashrc

sudo systemctl start cronie
sudo systemctl enable cronie

(cat cronjob.txt; crontab -l) | crontab -

prompt_user() {
  local prompt_message=$1
  read -p "$prompt_message [Y/N] " choice
  echo "$choice"
}

apps_choice=$(prompt_user "Do you wish to download all the apps?")

if [[ $apps_choice =~ ^[Yy]*$ ]] || [[ -z $apps_choice ]]; then
  ./install/install.sh
fi

echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."

for i in {10..1}; do
    echo "$i..."
    sleep 1
done

reboot
