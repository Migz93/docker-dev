#!/bin/bash

echo "AUTHORIZED_KEYS: $AUTHORIZED_KEYS"
# Set the authorized keys from the AUTHORIZED_KEYS environment variable (if provided)
if [ -n "$AUTHORIZED_KEYS" ]; then
    mkdir -p /root/.ssh
    echo "$AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
    chown -R root:root /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
    echo "Authorized keys set for user root"
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
fi

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
