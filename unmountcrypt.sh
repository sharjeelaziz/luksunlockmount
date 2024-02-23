#!/bin/bash

# Check if a mount point was passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mountPath>"
    exit 1
fi

mountPath="$1"

# Find the device mounted at the specified mount point and its mapper name
deviceInfo=$(lsblk -o MOUNTPOINT,NAME,TYPE -J | jq -r --arg MOUNTPOINT "$mountPath" '(.. | select(type == "object" and .mountpoint? == $MOUNTPOINT) | .name, .type)')

# Parse the device name and type
deviceName=$(echo "$deviceInfo" | head -n 1)
deviceType=$(echo "$deviceInfo" | tail -n 1)

echo $deviceName
echo $deviceType

# Check if the device is a LUKS volume
if [ "$deviceType" != "crypt" ]; then
    echo "The specified mount point does not appear to be a LUKS encrypted volume."
    exit 1
fi

# Unmount the filesystem
sudo umount "$mountPath"
if [ $? -ne 0 ]; then
    echo "Failed to unmount the volume at $mountPath."
    exit 1
fi
echo "Volume unmounted successfully from $mountPath."

# Close the LUKS volume
sudo cryptsetup luksClose "$deviceName"
if [ $? -ne 0 ]; then
    echo "Failed to close the LUKS volume $deviceName."
    exit 1
fi
echo "LUKS volume $deviceName closed successfully."

