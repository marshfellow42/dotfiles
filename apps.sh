#!/bin/bash

if ! command -v yay &> /dev/null; then
  echo "Error: yay is not installed. Please install yay first."
  exit 1
fi

if ! command -v flatpak &> /dev/null; then
  echo "Error: flatpak is not installed. Please install flatpak first."
  exit 1
fi

cd ~/Downloads || { echo "Failed to navigate to ~/Downloads"; exit 1; }

prompt_user() {
  local prompt_message=$1
  read -p "$prompt_message [Y/N] " choice
  echo "$choice"
}

developer_choice=$(prompt_user "Do you wish to download the Developer Suite?")
libreoffice_choice=$(prompt_user "Do you wish to download Libreoffice?")
creator_choice=$(prompt_user "Do you wish to download the Creator Suite?")
gaming_choice=$(prompt_user "Do you wish to download the Gaming Suite?")
media_choice=$(prompt_user "Do you wish to download the Media Suite?")
privacy_choice=$(prompt_user "Do you wish to download the Privacy Suite?")
ripper_choice=$(prompt_user "Do you wish to download the Ripper Suite?")
misc_choice=$(prompt_user "Do you wish to download the Misc Suite?")

if [[ $developer_choice =~ ^[Yy]*$ ]] || [[ -z $developer_choice ]]; then
  sudo pacman -Syu gnupg qemu virt-manager virt-viewer vde2 dnsmasq bridge-utils libvirt
  yay -Syu vscodium-bin
  sudo systemctl enable libvirtd
  sudo systemctl start libvirtd
  sudo usermod -aG libvirt,kvm "$USER"
fi

if [[ $libreoffice_choice =~ ^[Yy]*$ ]] || [[ -z $libreoffice_choice ]]; then
  sudo pacman -Syu libreoffice-fresh
fi

if [[ $creator_choice =~ ^[Yy]*$ ]] || [[ -z $creator_choice ]]; then
  sudo pacman -Syu krita blender godot handbrake tenacity
  yay -Syu beeref
  flatpak install https://nightly.gnome.org/repo/appstream/org.gimp.GIMP.Nightly.flatpakref
  flatpak install flathub com.github.libresprite.LibreSprite com.obsproject.Studio org.kde.kdenlive
fi

if [[ $gaming_choice =~ ^[Yy]*$ ]] || [[ -z $gaming_choice ]]; then
  sudo pacman -Syu base-devel clang git cmake sndio jack2 openal qt6-base qt6-declarative qt6-multimedia sdl2 vulkan-validation-layers
  sudo pacman -Syu lutris dolphin-emu retroarch syncthing
  yay -Syu emulationstation-de rpcs3-bin cemu ryujinx-git org.prismlauncher.PrismLauncher
  flatpak install flathub net.pcsx2.PCSX2 org.duckstation.DuckStation org.ppsspp.PPSSPP
  flatpak install --user https://sober.vinegarhq.org/sober.flatpakref
  git clone --recursive https://github.com/shadps4-emu/shadPS4.git
  cd shadPS4 || { echo "Failed to navigate to shadPS4 directory"; exit 1; }
  cmake --build . --parallel"$(nproc)"
  cd ../
fi

if [[ $media_choice =~ ^[Yy]*$ ]] || [[ -z $media_choice ]]; then
  sudo pacman -Syu mpv syncplay
  yay -Syu ani-cli mov-cli python-mov-cli-youtube python-mov-cli-jellyplex python-mov-cli-files foobar2000
  curl -O https://github.com/dream7180/foobox-en/releases/download/7.37/foobox_x64.en.v7.37-1.exe
  flatpak install flathub com.github.iwalton3.jellyfin-media-player
fi

if [[ $privacy_choice =~ ^[Yy]*$ ]] || [[ -z $privacy_choice ]]; then
  yay -Syu mullvad-browser-bin librewolf-bin torbrowser-launcher bisq
fi

if [[ $ripper_choice =~ ^[Yy]*$ ]] || [[ -z $ripper_choice ]]; then
  sudo pacman -Syu whipper
  yay -Syu makemkv
fi
