#!/bin/bash

if ! command -v yay &> /dev/null; then
   echo "Error: yay is not installed. Please install yay first."
   exit 1
fi

if ! command -v flatpak &> /dev/null; then
   echo "Error: flatpak is not installed. Please install flatpak first."
   exit 1
fi

cd ~/Downloads

echo "Updating system..."
~/update_all.sh

./apps/dev.sh
./apps/ricing.sh
./apps/artist.sh
./apps/gaming.sh
./apps/media.sh
./apps/privacy.sh
./apps/learn.sh

echo "Installation complete!"
