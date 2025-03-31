#!/usr/bin/env python3

from datetime import datetime
import os
from pathlib import Path
import random

os.environ["WAYLAND_DISPLAY"] = "wayland-1"
os.environ["XDG_RUNTIME_DIR"] = f"/run/user/{os.getuid()}"

current_hour = datetime.now().astimezone().hour
home_directory = Path.home()
wallpaper_directory = os.path.join(home_directory, "wallpapers")

if 0 <= current_hour <= 4:
    folder_name = "midnight"
elif 5 <= current_hour <= 12:
    folder_name = "morning"
elif 13 <= current_hour <= 17:
    folder_name = "afternoon"
elif 18 <= current_hour <= 23:
    folder_name = "night"

flag_file = f"/tmp/swww_{folder_name}_flag"

if not os.path.exists(flag_file):
    wallpaper_folder = os.path.join(wallpaper_directory, folder_name)

    if os.path.exists(wallpaper_folder):
        images = os.listdir(wallpaper_folder)
        if images:
            wallpaper = os.path.join(wallpaper_folder, random.choice(images))
            os.system(f'swww img "{wallpaper}" && wal -i "{wallpaper}"')
            with open(flag_file, "w") as f:
                f.write(str(current_hour))
