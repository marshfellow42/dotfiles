#!/usr/bin/env bash

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

# Exit on any error
set -e

source utils.sh

if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

echo "Starting system setup..."

echo "Updating system..."
sudo pacman -Syu --noconfirm

if ! command -v yay &> /dev/null; then
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
  yay -Y --gendb
  cd ~/dotfiles/
fi

echo "Installing essential packages..."
install_packages "${ESSENCIAL_APPS[@]}"

echo "Installing VSCodium Extensions..."
install_codium_extensions "${VSCODIUM_EXTENSIONS[@]}"

# I'm going to remove this if I'm choosing Thunar or Nemo, because this is only on Dolphin File Manager
if kbuildsycoca6 --noincremental 2>&1 | grep -q '"applications.menu"  not found in  QList'; then
  sudo update-desktop-database
  cd /etc/xdg/menus/
  sudo mv arch-applications.menu applications.menu
  kbuildsycoca6 --noincremental
  cd ~/dotfiles/
fi

install_flatpak_apps "${ESSENCIAL_FLATPAK_APPS[@]}"

install_packages "${FONTS[@]}"

cd stow/HOME
stow --target="$HOME" * --adopt
cd ../ROOT
mkdir -p /usr/local/share/fonts/
mkdir -p /usr/share/rofi/themes/
stow --target="/" * --adopt
cd ../..

git reset --hard

mkdir -p ~/Pictures/Screenshots/
mkdir -p ~/Downloads/
mkdir -p ~/Documents/
mkdir -p ~/Videos/
mkdir -p ~/Music/
mkdir -p ~/Trash/

sudo systemctl start cronie
sudo systemctl enable cronie

if ! (crontab -l 2>/dev/null; cat cronjob.txt) | crontab -; then
  printf '\n\n' >> cronjob.txt
  (crontab -l 2>/dev/null; cat cronjob.txt) | crontab -
fi

source ~/.bashrc

optional_apps_choice=$(prompt_user "Do you wish to download all the apps?")

if [[ $optional_apps_choice =~ ^[Yy]*$ ]] || [[ -z $optional_apps_choice ]]; then
  if ! command -v yay &> /dev/null; then
    echo "Error: yay is not installed. Please install yay first."
    exit 1
  fi

  if ! command -v flatpak &> /dev/null; then
    echo "Error: flatpak is not installed. Please install flatpak first."
    exit 1
  fi

  ~/update_all.sh

  install_flatpak_apps "${ART_FLATPAK_APPS[@]}"

  install_flatpak_apps "${GAMING_FLATPAK_APPS[@]}"

  URL="https://github.com/kamilburda/batcher/releases/download/1.0.2/batcher-1.0.2.zip"
  FILENAME=$(basename "$URL")
  DIRNAME="${FILENAME%.zip}"
  curl -O "$URL"
  unzip "$FILENAME" -d "$DIRNAME"
  mv "$DIRNAME/batcher" ~/.config/GIMP/plug-ins/
  rm "$FILENAME"
  rm -r "$DIRNAME"

  URL="https://fightcade.download/fc2json.zip"
  FILENAME=$(basename "$URL")
  DIRNAME="${FILENAME%.zip}"
  curl -O "$URL"
  unzip "$FILENAME" -d "$DIRNAME"
  mv "$DIRNAME"/* ~/.local/share/flatpak/fightcade/emulator
  rm "$FILENAME"
  rm -r "$DIRNAME"

  install_packages "${ART[@]}"

  install_packages "${MEDIA[@]}"

  install_packages "${DEV[@]}"

  install_packages "${GAMING[@]}"

  install_packages "${LEARN[@]}"

  install_packages "${PRIVACY[@]}"

  install_packages "${RICING[@]}"
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
