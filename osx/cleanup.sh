#!/bin/bash
# Call this script periodically to automatically delete aging downloaded files

DOWNLOAD_DIR="/Volumes/RAID/Usenet"
LABEL_DAYS=75
CLEAN_DAYS=90

# Remove all labels
echo "[cleanup.sh] Removing all labels"
find "$DOWNLOAD_DIR"/* -type d -exec \
  osascript >/dev/null -e "tell application \"Finder\" to set label index of alias POSIX file \""{}"\" to 0" \;

for folder in Anime Apps Books Consoles Games Incomplete Movies Music TV
do

  # Add labels to directories that are getting old
  echo "[cleanup.sh] Adding labels to directories that are getting old"
  find "$DOWNLOAD_DIR"/$folder/* -type d -mtime +"$LABEL_DAYS" -exec \
    osascript >/dev/null -e "tell application \"Finder\" to set label index of alias POSIX file \""{}"\" to 2" \;

  # Log the files that are really old
  find "$DOWNLOAD_DIR"/$folder/* -type d -mtime +"$CLEAN_DAYS" -exec \
    echo "[cleanup.sh] Deleting "{} \;
    # logger -t "[cleanup.sh] Deleting "{} \;

  # Delete the files that are really old
  # find "$DOWNLOAD_DIR"/$folder/* -type d -mtime +"$CLEAN_DAYS" -exec rm -rf {} \;
  echo "[cleanup.sh] Finished cleanup"

done
