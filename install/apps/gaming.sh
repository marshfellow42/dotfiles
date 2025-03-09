#!/bin/bash

if ! command -v yay &> /dev/null; then
   echo "Error: yay is not installed. Please install yay first."
   exit 1
fi

if ! command -v flatpak &> /dev/null; then
   echo "Error: flatpak is not installed. Please install flatpak first."
   exit 1
fi

# Install Pacman Packages
echo "Installing Pacman Packages..."
sudo pacman -S --noconfirm lutris dolphin-emu retroarch

# Install Yay Packages
echo "Installing Yay Packages..."
yay -S --noconfirm rpcs3-bin cemu ryujinx shadps4-git vita3k-git

# Install Flatpak Applications from Flathub
echo "Installing Flatpak Apps from Flathub..."
flatpak install -y flathub net.pcsx2.PCSX2 org.duckstation.DuckStation org.ppsspp.PPSSPP org.prismlauncher.PrismLauncher com.heroicgameslauncher.hgl

# Install Flatpak Links
echo "Installing Flatpak Links..."
flatpak install --user -y https://sober.vinegarhq.org/sober.flatpakref

echo "Installation complete!"
