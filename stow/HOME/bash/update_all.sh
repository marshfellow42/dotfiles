#!/usr/bin/env bash

FLAG_FILE="/tmp/update_all_flag"

THIS_WEEK=$(date +%V)

if [ -f "$FLAG_FILE" ]; then
    LAST_WEEK=$(cat "$FLAG_FILE")
    if [ "$LAST_WEEK" == "$THIS_WEEK" ]; then
        exit 0
    fi
fi

echo "$THIS_WEEK" > "$FLAG_FILE"

kitty

yay --noconfirm

flatpak update -y

python3 -m pip install --upgrade pip

python3 -m pip install --upgrade pipx

pipx upgrade-all

gem update