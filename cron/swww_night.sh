#!/bin/bash

# Check if the flag for the morning exists
if [ ! -f /tmp/swww_night_flag ]; then
    # Run the swww-img command
    swww-img
    # Create the flag file to indicate it has run
    touch /tmp/swww_night_flag
fi
