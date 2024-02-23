# LUKS Volume Manager with HashiCorp Vault

This repository contains two shell scripts designed to facilitate the secure handling of LUKS encrypted volumes in Linux. The first script, `mountcrypt.sh`, automates the process of retrieving encryption keys from HashiCorp Vault, unlocking the encrypted volume, and mounting it to a specified directory. The second script, `unmountcrypt.sh`, safely unmounts the volume and closes the LUKS container.

## Prerequisites

Before using these scripts, ensure you have the following prerequisites installed on your system:

- `cryptsetup`: For LUKS volume management.
- `curl`: For interacting with the HashiCorp Vault API.
- `jq`: For parsing JSON responses from Vault.

Additionally, you should have:

- A running HashiCorp Vault instance with access to the secrets.
- Properly configured permissions for the Vault token to retrieve the keys.

## Configuration

1. **Vault Configuration**: Set up your Vault server and store the LUKS keys as secrets. Ensure your Vault token has the necessary permissions to access these secrets.
    
2. **Environment Variables**:
    
    - `VAULT_TOKEN`: This environment variable must be set with your Vault access token before running the scripts.

## Usage

### Mounting Encrypted Volumes

To mount an encrypted volume, use the `mountcrypt.sh` script with the following syntax:

bash

`./mountcrypt.sh <Path to Encrypted Image> <Mount Point>`

Example:

bash

`./mountcrypt.sh /path/to/encrypted.img /mnt/myvolume`

### Unmounting Encrypted Volumes

To unmount and close an encrypted volume, use the `unmountcrypt.sh` script with the following syntax:

bash

`./unmountcrypt.sh <Mount Point>`

Example:

bash

`./unmountcrypt.sh /mnt/myvolume`

This script will automatically detect the LUKS volume associated with the mount point, unmount it, and securely close the volume.

## Security Considerations

- Do not hard-code your Vault token or any sensitive information within the scripts.
- Ensure the scripts are executed in a secure environment, with minimal permissions necessary.
- Regularly rotate your Vault tokens and encryption keys according to your security policy.

## Troubleshooting

- Verify that all prerequisites are installed and accessible.
- Ensure your Vault token is correctly set and has the necessary permissions.
- Check the paths and names used in the scripts for accuracy.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
