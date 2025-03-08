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
sudo pacman -S --noconfirm krita blender tenacity

# Install Yay Packages
echo "Installing Yay Packages..."
yay -S --noconfirm beeref aseprite

# Install Flatpak Applications from Flathub
echo "Installing Flatpak Apps from Flathub..."
flatpak install -y flathub com.obsproject.Studio org.kde.kdenlive

# Install Flatpak Links
echo "Installing Flatpak Links..."
flatpak install -y https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref

echo "Installing GIMP plugin..."
curl -O https://github.com/kamilburda/batcher/releases/download/1.0-RC3/batcher-1.0-RC3.zip
unzip batcher-1.0-RC3.zip
mv batcher ~/.config/GIMP/plug-ins/
rm batcher-1.0-RC3.zip

echo "Installation complete!"
