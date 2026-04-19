#!/usr/bin/env bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git and try again."
    exit 1
fi

# Clone to a hidden directory in home, or skip if it exists
TARGET="$HOME/dotfiles"

if [ ! -d "$TARGET" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/marshfellow42/dotfiles.git "$TARGET"
else
    echo "Dotfiles directory already exists. Skipping clone."
fi

# Move into the directory and run setup
cd "$TARGET" || exit
chmod +x install/setup.py
./install/setup.py