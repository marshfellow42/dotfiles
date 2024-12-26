#!/usr/bin/bash

STATE_FILE="/tmp/script_state"

function set_state {
    echo "$1" > "$STATE_FILE"
}

function get_state {
    [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo "start"
}

state=$(get_state)

if [[ "$state" == "start" ]]; then
    cd ~/Downloads || { echo "Error: Cannot access ~/Downloads"; exit 1; }

    if ! pacman -Syu git go fastfetch gimp krita mpv flatpak syncplay libreoffice-fresh whipper godot figlet lutris dolphin-emu retroarch blender handbrake syncthing; then
        echo "Error: Failed to install packages with pacman."
        exit 1
    fi

    git clone https://aur.archlinux.org/yay.git || { echo "Error: Failed to clone yay"; exit 1; }
    cd yay || { echo "Error: Failed to access yay directory"; exit 1; }
    makepkg -si || { echo "Error: Failed to build yay"; exit 1; }
    cd ../

    yay -Syu vscodium-bin mullvad-browser-bin librewolf-bin ani-cli makemkv beeref foobar2000 emulationstation-de rpcs3-bin cemu ryujinx-git

    sudo pacman -Syu base-devel clang git cmake sndio jack2 openal qt6-base qt6-declarative qt6-multimedia sdl2 vulkan-validation-layers
    git clone --recursive https://github.com/shadps4-emu/shadPS4.git || { echo "Error: Failed to clone ShadPS4"; exit 1; }
    cd shadPS4 || { echo "Error: Failed to access ShadPS4 directory"; exit 1; }
    cmake --build . --parallel$(nproc) || { echo "Error: Failed to build ShadPS4"; exit 1; }
    cd ../

    curl -O https://github.com/dream7180/foobox-en/releases/download/7.37/foobox_x64.en.v7.37-1.exe || { echo "Error: Failed to download foobox"; exit 1; }

    set_state "post-reboot"
    echo "Rebooting in 10 seconds... Press Ctrl+C to cancel."
    sleep 10
    reboot
fi

if [[ "$state" == "post-reboot" ]]; then
    flatpak install flathub org.torproject.torbrowser-launcher net.pcsx2.PCSX2 org.duckstation.DuckStation org.ppsspp.PPSSPP com.obsproject.Studio com.github.libresprite.LibreSprite org.kde.kdenlive com.github.iwalton3.jellyfin-media-player org.prismlauncher.PrismLauncher

    flatpak install --user https://sober.vinegarhq.org/sober.flatpakref
    
    rm -f "$STATE_FILE"
    echo "Script completed!"
fi

cd ~/

if ! grep -q "fastfetch" ~/.bashrc; then
    echo 'if [[ $- == *i* ]]; then fastfetch; fi' >> ~/.bashrc
fi

source ~/.bashrc
