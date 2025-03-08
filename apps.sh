#!/bin/bash

if ! command -v yay &> /dev/null; then
   echo "Error: yay is not installed. Please install yay first."
   exit 1
fi
 
if ! command -v flatpak &> /dev/null; then
   echo "Error: flatpak is not installed. Please install flatpak first."
   exit 1
fi 

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install Pacman Packages
echo "Installing Pacman Packages..."
sudo pacman -S --noconfirm gnupg libreoffice-fresh krita blender godot handbrake tenacity lutris dolphin-emu retroarch syncthing mpv syncplay whipper qbittorrent

# Install Yay Packages
echo "Installing Yay Packages..."
yay -S --noconfirm vscodium-bin beeref rpcs3-bin cemu ryujinx-git shadps4-git ani-cli mullvad-browser-bin librewolf-bin torbrowser-launcher bisq makemkv anki-bin aseprite hoppscotch-bin

# Install Flatpak Applications from Flathub
echo "Installing Flatpak Apps from Flathub..."
flatpak install -y flathub com.obsproject.Studio org.kde.kdenlive net.pcsx2.PCSX2 org.duckstation.DuckStation org.ppsspp.PPSSPP org.prismlauncher.PrismLauncher com.heroicgameslauncher.hgl com.github.iwalton3.jellyfin-media-player

# Install Flatpak Links
echo "Installing Flatpak Links..."
flatpak install -y https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref
flatpak install --user -y https://sober.vinegarhq.org/sober.flatpakref 

echo "Installing GIMP plugin..."
curl -O https://github.com/kamilburda/batcher/releases/download/1.0-RC3/batcher-1.0-RC3.zip
unzip batcher-1.0-RC3.zip 
mv batcher ~/.config/GIMP/plug-ins/
rm batcher-1.0-RC3.zip

echo "Installation complete!"
