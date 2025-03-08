#!/bin/bash

# Directory containing the images in the home directory
IMAGE_DIR="$HOME/wallpaper"

# Get a list of all PNG files in the directory
FILES=("$IMAGE_DIR"/*.png)

# Count the number of files
FILE_COUNT=${#FILES[@]}

# Ensure there are PNG files before proceeding
if [ "$FILE_COUNT" -gt 0 ]; then
    # Generate a random index
    RANDOM_INDEX=$(( RANDOM % FILE_COUNT ))

    # Get the random image file
    RANDOM_IMAGE="${FILES[$RANDOM_INDEX]}"

    # Print or use the filename
    echo "Selected Image: $RANDOM_IMAGE"
else
    echo "No PNG files found in $IMAGE_DIR"
    exit 1
fi

# Check if the flag for the morning exists
if [ ! -f /tmp/swww_midnight_flag ]; then
    # Run the swww-img command with the selected image
    swww-img "$RANDOM_IMAGE"

    # Create the flag file to indicate it has run
    touch /tmp/swww_midnight_flag
fi
