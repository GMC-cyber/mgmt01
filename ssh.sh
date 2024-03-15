#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME="$1"

useradd -m -s /bin/bash "$USERNAME"

echo "Please provide the path to the public key file (e.g., /path/to/id_rsa.pub):"
read PUBKEY_PATH

if [ ! -f "$PUBKEY_PATH" ]; then
    echo "Public key file not found."
    exit 1
fi

mkdir -p "/home/$USERNAME/.ssh"
cat "$PUBKEY_PATH" >> "/home/$USERNAME/.ssh/authorized_keys"
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"
chmod 700 "/home/$USERNAME/.ssh"
chmod 600 "/home/$USERNAME/.ssh/authorized_keys"

echo "User $USERNAME has been created, and the public key has been imported."
