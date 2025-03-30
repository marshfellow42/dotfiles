#!/bin/bash

if ! command -v yay &> /dev/null; then
   echo "Error: yay is not installed. Please install yay first."
   exit 1
fi

if ! command -v flatpak &> /dev/null; then
   echo "Error: flatpak is not installed. Please install flatpak first."
   exit 1
fi

# Install Yay Packages
echo "Installing Yay Packages..."
yay -S --noconfirm mullvad-browser-bin librewolf-bin tor-browser-bin bisq --noconfirm

echo "Installation complete!"
