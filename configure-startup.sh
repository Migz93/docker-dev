#!/bin/bash

# Check if AUTHORIZED_KEYS is provided (mandatory)
echo "Checking for AUTHORIZED_KEYS environment variable..."
if [ -z "$AUTHORIZED_KEYS" ]; then
    echo "ERROR: AUTHORIZED_KEYS environment variable is mandatory but was not provided."
    echo "Please provide SSH public key(s) via the AUTHORIZED_KEYS environment variable."
    exit 1
fi

# Set the authorized keys from the AUTHORIZED_KEYS environment variable
echo "Setting up SSH with provided authorized keys..."
mkdir -p /root/.ssh
echo "$AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
chown -R root:root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
echo "Authorized keys set for user root"
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Configure Git user if environment variables are set
if [ -n "$GIT_USER" ]; then
    echo "Setting Git user.name to $GIT_USER"
    git config --global user.name "$GIT_USER"
fi

if [ -n "$GIT_EMAIL" ]; then
    echo "Setting Git user.email to $GIT_EMAIL"
    git config --global user.email "$GIT_EMAIL"
fi

# Use SSH_PORT environment variable or default to 22
SSH_PORT=${SSH_PORT:-22}
echo "Starting SSH server on port $SSH_PORT..."
exec /usr/sbin/sshd -D -p $SSH_PORT
