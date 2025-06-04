#!/bin/bash

# Laravel Deployment Script using Ansible
echo "=== Laravel Deployment Script ==="

# Change to ansible directory
cd "$(dirname "$0")"

# Test connection first
echo "Testing connection to remote server..."
ansible myservers -m ping

if [ $? -eq 0 ]; then
    echo "✓ Connection successful!"
    echo "Running Laravel deployment playbook..."
    ansible-playbook playbook.yml -v
else
    echo "✗ Connection failed. Please check your inventory.ini and server configuration."
    exit 1
fi

echo "=== Deployment Complete ==="