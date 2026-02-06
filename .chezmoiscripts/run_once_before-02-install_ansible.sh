#!/usr/bin/env bash

install_on_fedora() {
    sudo dnf install -y ansible
}

install_on_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y ansible
}

install_on_arch() {
    sudo pacman -Syu
    sudo pacman -S ansible
}

install_on_mac() {
    brew install ansible
}

OS="$(uname -s)"

case "$OS" in
    Linux)
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                arch)
                    install_on_arch
                    ;;
                *)
                    echo "Unsupported Linux distribution: $ID"
                    exit 1
                    ;;
            esac
        else
            echo "Cannot detect Linux distribution"
            exit 1
        fi
        ;;
    Darwin)
        install_on_mac
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

ansible-galaxy collection install kewlfft.aur

ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass

echo "Ansible installation complete."

