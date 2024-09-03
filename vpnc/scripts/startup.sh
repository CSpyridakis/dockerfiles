#!/bin/bash

# Enable ssh
ufw enable
ufw allow ssh

# Change root user password
echo 'root:veryhardpass' | chpasswd

# Create user for ssh connections 
useradd docker 
adduser docker root
echo 'docker:veryhardpass' | chpasswd

# Start ssh
service ssh start

# Copy ssh specific files here
mkdir -p /home/docker/.ssh/
cp /home/ssh/authorized_keys /home/docker/.ssh/