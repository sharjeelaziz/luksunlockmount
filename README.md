# Vault LUKS Mounter

This Bash script automates the process of retrieving LUKS encryption keys from a HashiCorp Vault instance, using them to unlock encrypted disk images, and then mounting those images to a specified directory.

## Prerequisites

Before using this script, ensure you have the following installed and configured on your system:

- `curl`: For making API requests to HashiCorp Vault.
- `jq`: For parsing JSON responses from the Vault API.
- `cryptsetup`: For managing LUKS encrypted volumes.

Additionally, you must have:

- A running HashiCorp Vault server accessible from the machine where the script will be executed.
- The Vault CLI or API access configured and a valid token with permissions to read secrets.

## Configuration

1. **Environment Variables**:
   
   - `VAULT_TOKEN`: Your Vault authentication token. This script reads the token from this environment variable.
   
   Before running the script, export your Vault token as follows:
   ```bash
   export VAULT_TOKEN="your_vault_token_here"
   ```

2. **Script Variables** (Edit in the script):
   
   - `vaultAddr`: The address of your HashiCorp Vault server (e.g., `http://your_vault_server:8200`).
   - `secretPath`: The path in Vault where your LUKS key is stored (e.g., `secret/data/yourSecretPath`).

## Usage

To use the script, you need to pass the path of the encrypted disk image and the mount path as arguments.

```bash
./mount_encrypted_images.sh /path/to/encrypted/image.img /path/to/mount/point
```

### Example:

```bash
./mount_encrypted_images.sh /mnt/data/vault/encrypted-disk.img /mnt/decrypted
```

This command retrieves the LUKS key for the specified image from Vault, unlocks the image, and mounts it to the specified mount point.

## Security Considerations

- **Do not hard-code** your Vault token or any sensitive information in the script.
- Ensure that **permissions for the script** are set to prevent unauthorized access or modification.
- Regularly **rotate your Vault tokens** and encryption keys in line with your organization's security policies.
- Use this script in a **secure and trusted environment** to avoid exposing sensitive information.

## Troubleshooting

- Ensure all prerequisites are installed and properly configured.
- Verify that the `VAULT_TOKEN` environment variable is set with a valid token.
- Confirm that the Vault server address and secret path in the script are correct.
- Check the permissions of the disk image and mount point to ensure the script can access them.

## License

This script is provided "as is", without warranty of any kind. Use it at your own risk.
