#!/usr/bin/env bash

EVENT_TYPE="$1"

# Log USB event details
echo "[USB $EVENT_TYPE] $(date)" >> /tmp/usb-sound-udev.log
echo "Trying to play sound..." >> /tmp/usb-sound-udev.log

# Select sound based on event type
if [[ "$EVENT_TYPE" == "add" ]]; then
  SOUND="/usr/share/sounds/custom/windows-hardware-insert.mp3"
elif [[ "$EVENT_TYPE" == "remove" ]]; then
  SOUND="/usr/share/sounds/custom/windows-hardware-remove.mp3"
fi

# Play sound if the file exists
if [[ -f "$SOUND" ]]; then
  sudo play "$SOUND" >> /tmp/usb-sound-udev.log 2>&1
  echo "play exit status: $?" >> /tmp/usb-sound-udev.log
else
  echo "Sound file not found: $SOUND" >> /tmp/usb-sound-udev.log
fi