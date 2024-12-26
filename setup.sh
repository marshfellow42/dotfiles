pacman -Syu git hyprcursor hyprlock hypridle hyprshot rofi-wayland jq swww waybar

git clone https://aur.archlinux.org/yay.git || { echo "Error: Failed to clone yay"; exit 1; }
cd yay || { echo "Error: Failed to access yay directory"; exit 1; }
makepkg -si || { echo "Error: Failed to build yay"; exit 1; }
cd ../
