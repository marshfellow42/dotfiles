#!/usr/bin/env bash

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &> /dev/null
}

# Function to check if a package is installed
is_group_installed() {
  pacman -Qg "$1" &> /dev/null
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg" && ! is_group_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    yay -Syu --noconfirm "${to_install[@]}"
  fi
}

install_codium_extensions() {
  local extensions=("$@")
  local to_install=()

  for ext in "${extensions[@]}"; do
    if ! codium --list-extensions | grep -q "^$ext$"; then
      to_install+=("$ext")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing VSCodium extensions: ${to_install[*]}"
    for ext in "${to_install[@]}"; do
      codium --install-extension "$ext"
    done
  else
    echo "All VSCodium extensions are already installed."
  fi
}

install_flatpak_apps() {
  local apps=("$@")
  local to_install=()

  # Ensure Flathub is added
  if ! flatpak remote-list | grep -q "^flathub"; then
    echo "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi

  for app in "${apps[@]}"; do
    if ! flatpak list --app --columns=application | grep -q "^$app$"; then
      to_install+=("$app")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing Flatpak apps from Flathub: ${to_install[*]}"
    flatpak install -y flathub "${to_install[@]}"
  else
    echo "All Flatpak apps are already installed."
  fi
}