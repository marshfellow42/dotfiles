#!/bin/bash

if ! command -v yay &> /dev/null; then
   echo "Error: yay is not installed. Please install yay first."
   exit 1
fi

if ! command -v flatpak &> /dev/null; then
   echo "Error: flatpak is not installed. Please install flatpak first."
   exit 1
fi

echo "Installing Arch Packages..."
yay -S --noconfirm beeref aseprite krita blender audacity lmms --noconfirm

echo "Installing Flatpak Apps from Flathub..."
flatpak install -y flathub com.obsproject.Studio org.kde.kdenlive

echo "Installing Flatpak Links..."
flatpak install -y https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref

echo "Installing GIMP plugin..."
URL="https://github.com/kamilburda/batcher/releases/download/1.0/batcher-1.0.zip"
FILENAME=$(basename "$URL")
DIRNAME="${FILENAME%.zip}"
curl -O "$URL"
unzip "$FILENAME" -d "$DIRNAME"
mv "$DIRNAME/batcher" ~/.config/GIMP/plug-ins/
rm "$FILENAME"
rm -r "$DIRNAME"

echo "Installation complete!"
