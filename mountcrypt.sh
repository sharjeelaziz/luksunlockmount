#!/bin/bash

# Define your Vault server address and secret paths here
vaultAddr="http://192.168.4.200:8200" # Change this to your Vault server address
secretPath="cubbyhole/luks_keys" # Change this to the path where your LUKS key is stored in Vault

# Check if the correct number of arguments were passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <imagePath> <mountPath>"
    exit 1
fi

# Assign command line arguments to variables
imagePath="$1"
mountPath="$2"

# Check if VAULT_TOKEN is set
if [ -z "$VAULT_TOKEN" ]; then
    echo "VAULT_TOKEN is not set. Please export VAULT_TOKEN with your Vault access token."
    exit 1
fi

# Extract the filename with extension
filenameExt="${imagePath##*/}"

# Remove the extension to get just the filename
luksVolume="${filenameExt%.*}"

# Function to get LUKS key from Vault
getLuksKeyFromVault() {
    curl --header "X-Vault-Token: $VAULT_TOKEN" \
         --request GET \
         "${vaultAddr}/v1/${secretPath}" 2>/dev/null | jq -r '.data' | jq -r --arg key "$luksVolume" '.[$key]'
}

# Retrieve the LUKS key
luksKey=$(getLuksKeyFromVault)

if [ -z "$luksKey" ]; then
    echo "Failed to retrieve LUKS key from Vault."
    exit 1
fi

# Unlock the disk image
echo "$luksKey" | sudo cryptsetup luksOpen "$imagePath" "$luksVolume" --key-file=-

if [ $? -ne 0 ]; then
    echo "Failed to unlock the LUKS volume."
    exit 1
fi

# Create the mount point directory if it doesn't exist
mkdir -p "$mountPath"

# Mount the filesystem
sudo mount /dev/mapper/"$luksVolume" "$mountPath"

if [ $? -ne 0 ]; then
    echo "Failed to mount the LUKS volume."
    sudo cryptsetup luksClose "$luksVolume"
    exit 1
fi

echo "Volume mounted successfully at $mountPath."

