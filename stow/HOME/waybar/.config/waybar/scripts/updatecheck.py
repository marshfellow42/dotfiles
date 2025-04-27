#!/usr/bin/env python3

import subprocess
import json

def check(command):
    """Check if a command exists."""
    return subprocess.run(["command", "-v", command], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0

def string_to_len(string, length):
    """Trim or pad a string to a given length."""
    return (string[:length - 2] + "..") if len(string) > length else string.ljust(length)

def get_updates():
    """Get Arch and AUR updates."""
    try:
        result = subprocess.run(["checkupdates-with-aur"], capture_output=True, text=True, check=True)
        return result.stdout.strip().split("\n")
    except subprocess.CalledProcessError:
        return []

def get_flatpak_updates():
    """Get Flatpak updates."""
    try:
        result = subprocess.run(["flatpak", "remote-ls", "--update"], capture_output=True, text=True, check=True)
        return result.stdout.strip().split("\n")
    except subprocess.CalledProcessError:
        return []

def main():
    updates = get_updates()
    flatpak_updates = get_flatpak_updates()

    text = str(len(updates)) if updates else ""
    tooltip = f"<b>{text}  updates (arch+aur) </b>\n" if updates else ""
    tooltip += f" <b>{string_to_len('PkgName', 20)} {string_to_len('PrevVersion', 20)} {string_to_len('NextVersion', 20)}</b>\n" if updates else ""

    for update in updates:
        parts = update.split()
        if len(parts) >= 4:
            tooltip += f"<b> {string_to_len(parts[0], 20)} </b>{string_to_len(parts[1], 20)} {string_to_len(parts[3], 20)}\n"

    for flatpak in flatpak_updates:
        tooltip += f"<b> Flatpak: </b>{string_to_len(flatpak, 20)}\n"

    print(json.dumps({"text": text, "tooltip": tooltip.strip()}))

if __name__ == "__main__":
    main()
