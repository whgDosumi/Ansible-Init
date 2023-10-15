#!/bin/bash

# Set up a node for Ansible

ANSIBLE_USER="ansible"

# Create the Ansible user if it doesn't exist
if ! id "$ANSIBLE_USER" &>/dev/null; then
    sudo useradd "$ANSIBLE_USER"
fi

# Public keys are added to the users authorized keys file. 
SSH_PUBLIC_KEYS=(
    # Control vm on my primary workstation
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyrwXTLjOD06CFOgHMF/kQVX8L8Ue1TsClR1N4xOXdXTB+OZeF0YmV0NrZ3oJETlhL8in6PbgDnMZOH9GV9b9ePeed0mxig46tgnlniEDjiflrePGf9qnhJCyKCJCT+AVeumhTgTQN+HNVPecZKJA1xhYW0zJIX/Ru4gA6WAbcFJ573i94llPdvD9CauNzaDwX3qIOWufoo+PZbE2EFjx1U2hc6hFIaDc3l35VgH0WEbGntlEeAd+Ibju2x/Or45n+xE5XQU/CRl1DuqVYMZV2WSiTbALDm9t/BNW1vgzdvayH8GXXGCXQ1GSw6mWrzXwD3B/Sf06f6m8pxdbGlJj99AJ7rN80up8wR/PjzxzLmeGRSkPCy76FzIhr5EiV0VBoG5GMtlEiUuwcCfF/O8TQB4On+wV5k8CdYRwaywWVYsUjxG4pHc9HF4ZplgLPGiZP2sD5xTdIJ/uvuLdCmSU52uxuxu59jiNYPjI5ZHTgHMjC0sTWs+m9dZXUisFiHBE= dlewis@onion-prod"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMgecSeApOwMJjzl9J0mphT0k0J2dZ1kB6XbHLS+v4RLfC38rROItXNVtDqTbM8aB8IyNmUP9BFDfGreXjg0bNUL7GmqktgvzhL8jmaxfBUYO2569kyrJ2p5sJFbZa24IfA9Pbg3nZIHWNyklalUyUym349LIwS3X2tMLr5us/UpdX4NYIB71gqZaXvdIf9yE6ajk+GfTceGZr/+2GbXKVqTZTDEE812UOt7Vsu6Cri4Dd/W/FXcd6/JOv57Wr3zuNHwuf6w5uEN0wUedWCuG5JGvi2wum5Y51SJh4d/6pTRQyjDfVYN45mbZv3MknUFU1bFllX0xhIE2irM9kD+ZEKyVCPp23OD2puCWsRrQ71nrOZC5nrtsIYeEhy9r4GjjPMZnF9kxZtJDE3KZb3m1ZwZgL00pvNumrNHm0fGhA60K7DMHB4MGEF6r6fZOYwjFydJGS6a+/FRUiEZAXBrcQXwi1SGMa/emq+4f9vnigOzbYIVoPmuHykOzC62xWznU= jenkins@onion-prod"
    # Additional keys can be added on new lines
)

# Create the .ssh directory for the Ansible user if it doesn't exist
SSH_DIR="/home/$ANSIBLE_USER/.ssh"
if [ ! -d "$SSH_DIR" ]; then
    sudo mkdir "$SSH_DIR"
    sudo chown -R "$ANSIBLE_USER:$ANSIBLE_USER" "$SSH_DIR"
fi

# Create the authorized_keys file and add the SSH public keys
AUTHORIZED_KEYS_FILE="$SSH_DIR/authorized_keys"
for key in "${SSH_PUBLIC_KEYS[@]}"; do
    echo "$key" | sudo tee -a "$AUTHORIZED_KEYS_FILE" >/dev/null
done

# Set proper permissions for the .ssh directory and authorized_keys file
sudo chown -R "$ANSIBLE_USER:$ANSIBLE_USER" "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"
sudo chmod 600 "$AUTHORIZED_KEYS_FILE"

# Add Ansible user to sudoers
sudo bash -c "echo '$ANSIBLE_USER ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
