#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install Pacman Packages
echo "Installing Pacman Packages..."
sudo pacman -S --noconfirm gnupg libreoffice-fresh krita blender godot handbrake tenacity lutris dolphin-emu retroarch syncthing mpv syncplay whipper

# Install Yay Packages
echo "Installing Yay Packages..."
yay -S --noconfirm vscodium-bin beeref rpcs3-bin cemu ryujinx-git shadps4-git ani-cli mullvad-browser-bin librewolf-bin torbrowser-launcher bisq makemkv

# Install Flatpak Applications from Flathub
echo "Installing Flatpak Apps from Flathub..."
flatpak install -y flathub com.github.libresprite.LibreSprite com.obsproject.Studio org.kde.kdenlive net.pcsx2.PCSX2 org.duckstation.DuckStation org.ppsspp.PPSSPP org.prismlauncher.PrismLauncher com.heroicgameslauncher.hgl com.github.iwalton3.jellyfin-media-player

# Install Flatpak Links
echo "Installing Flatpak Links..."
flatpak install -y https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref
flatpak install -y https://sober.vinegarhq.org/sober.flatpakref

echo "Installation complete!"
