#!/bin/bash 
#
# Responsible to install the Chef Server Standalone version 

echo "Installing the chef client"
curl -L https://omnitruck.chef.io/install.sh | bash

# Define the DNS name 
echo "192.168.30.30 chef-server.labs.in chef-server" >> /etc/hosts
echo "192.168.30.40 chef-client.labs.in chef-client" >> /etc/hosts