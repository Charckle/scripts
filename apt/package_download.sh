#!/bin/bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <package1> [package2 ...]"
  exit 1
fi

# Iterate over the provided package names
for package in "$@"; do
  # Run the apt-get command for each package and append to the download-list file
  sudo apt-get --allow-unauthenticated -y install --print-uris "$package" | cut -d\' -f2 | grep -E 'https?://' >> download-list
done

echo "Download list updated successfully."

