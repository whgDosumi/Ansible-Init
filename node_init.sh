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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwVXuC3Ub53Xx85NOQt1Jk+mT2BoMVO0dfusqAcrPgVYys/tJs8+eDWgznH9/7hQ8D8xPOMXpl+Bl+wweknCmiLG8047PBWQs0nKmRha8BbauLnifdliVsze6ho70UwYm10G0SbC6olzAz7KH0bh/cPBvOqagByqADnS1jWpX+xw3P2iUtOEm2ds2lPJMg69xhLArXcoBQ2pmX1u0K4+OUIEOcT6tpLKX8tZRX280lY1KQLVgPfLxY5sEG1l9Hg8Ro4PV/9sksgDGXXUk56U96mkxdFHDnzmbVrX1d+jrbxnHrA0FacAdXNENUNssy82CxvmCf/cADui6vqK9BZlc9JluQEYmxsVtpPsaQ1VtPiJTiRZ7XmYjzEE5xHMVwv80qRjT432uxcOFVtxcQQdbIXMWxQkCeKigRXgUKRqggBaoMWtR3wavQSQVL3fcOY8CV46V1k7716o81jchhPe/HEoHKNojqxH1ayav+Mf60ulI9SpuOrQB0/jgg6GchHW8= ansible@control"
    
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
sudo chmod 700 "$SSH_DIR"
sudo chmod 600 "$AUTHORIZED_KEYS_FILE"

# Add Ansible user to sudoers
sudo bash -c "echo '$ANSIBLE_USER ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
