from datetime import datetime
import os
from pathlib import Path
import random

current_hour = int(datetime.now().astimezone().strftime("%H"))
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

wallpaper_folder = os.path.join(wallpaper_directory, folder_name)

if os.path.exists(wallpaper_folder):
    images = os.listdir(wallpaper_folder)
    if images: 
        wallpaper = os.path.join(wallpaper_folder, random.choice(images))
        os.system(f'swww-img {wallpaper}')
    else:
        print(f"No images found in {wallpaper_folder}")
else:
    print(f"Folder {wallpaper_folder} does not exist")
