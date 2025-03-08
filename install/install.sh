#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Run category-specific installation scripts from the apps folder
./apps/dev.sh
./apps/artist.sh
./apps/gaming.sh
./apps/media.sh
./apps/privacy.sh
./apps/learn.sh

echo "Installation complete!"
