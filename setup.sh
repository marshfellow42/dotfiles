#!/bin/bash

print_logo() {
    cat << "EOF"

  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
EOF
}

clear
print_logo

prompt_user() {
  local prompt_message=$1
  read -p "$prompt_message [Y/N] " choice
  echo "$choice"
}

if ! command -v yay &> /dev/null; then
  sudo pacman -Syu --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
  yay -Y --gendb
  cd ~/dotfiles/
fi

yay -Syu --noconfirm hyprshot librewolf-bin fastfetch hyprcursor hyprlock hypridle rofi-wayland swww waybar swaync cliphist flatpak cronie mpv featherpad ttf-jetbrains-mono-nerd archlinux-xdg-menu python-pywal16 kde-cli-tools gnupg vscodium-bin oh-my-posh-bin checkupdates-with-aur stow

codium --install-extension vscode-icons-team.vscode-icons dracula-theme.theme-dracula ms-python.python ms-python.debugpy esbenp.prettier-vscode formulahendry.code-runner html-validate.vscode-html-validate laravel.vscode-laravel

if kbuildsycoca6 --noincremental 2>&1 | grep -q '"applications.menu"  not found in  QList'; then
  sudo update-desktop-database
  cd /etc/xdg/menus/
  sudo mv arch-applications.menu applications.menu
  kbuildsycoca6 --noincremental
  cd ~/dotfiles/
fi

flatpak install -y flathub org.kde.gwenview org.kde.kcalc

cd stow
git clone --branch timeofday --depth=1 https://github.com/marshfellow42/wallpapers.git ./wallpapers/wallpapers
git clone https://github.com/marshfellow42/fonts.git ./fonts/.fonts
stow --target="$HOME" *
cd ..

mkdir -p ~/Pictures/Screenshots/
mkdir -p ~/Downloads/
mkdir -p ~/Documents/
mkdir -p ~/Videos/
mkdir -p ~/Music/
mkdir -p ~/Trash/

source ~/.bashrc

sudo systemctl start cronie
sudo systemctl enable cronie

if ! (crontab -l 2>/dev/null; cat cronjob.txt) | crontab -; then
  printf '\n\n' >> cronjob.txt
  (crontab -l 2>/dev/null; cat cronjob.txt) | crontab -
fi

optional_apps_choice=$(prompt_user "Do you wish to download all the apps?")

if [[ $optional_apps_choice =~ ^[Yy]*$ ]] || [[ -z $optional_apps_choice ]]; then
  ./install/install.sh
fi

echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."

for i in {10..1}; do
  echo -n "$i"
  sleep 0.25
  echo -n "."
  sleep 0.25
  echo -n "."
  sleep 0.25
  echo -n "."
  sleep 0.25
done

reboot
