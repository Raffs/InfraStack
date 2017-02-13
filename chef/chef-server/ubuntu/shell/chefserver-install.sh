#!/bin/bash 
#
# Responsible to install the Chef Server Standalone version 

_PKG_URL='https://packages.chef.io/files/stable/chef-server/12.12.0/ubuntu/14.04/chef-server-core_12.12.0-1_amd64.deb'
_PKG_FILE='/tmp/install.deb'

# Ensure base tools are installed 
apt-get update && apt-get install \
    wget curl nano vim 

# Installing the chef packages
wget $_PKG_URL -O $_PKG_FILE
if [[ $? -eq 0 ]]; then
    if [[ -f $_PKG_FILE ]]; then
        dpkg -i $_PKG_FILE
        if [[ $? -ne 0 ]]; then
            echo "Error on trying to install the downloaded package"
            exit 3
        fi
    else
        echo "Could not find the downloaded package"
        exit 2
    fi
    
else
    echo "Error on trying to Download the Chef Server package"
    exit 1
fi

# Setup the chef servers 
chef-server-ctl reconfigure
if [[ $? -ne 0 ]]; then
    echo "Could not setup the chef server standalone"
    exit 3
fi

# Delay deployment, waiting until the chef services
# becames available
echo "Waiting until the chef-server becames available" && sleep 30

# Setup the administrative user
chef-server-ctl user-create \
    admin Administrator Infrastack admin@infrastack.com.br 'admin@chef' \
    --filename ~/chef.key
echo "Created user admin: password: admin@chef"

# Setup an organization
chef-server-ctl org-create \
    infrastack 'InfraStack Inc' \
    --association_user admin \
    --filename ~/validator-org.pem
echo "Created company InfraStack Inc"

# Adding some configuration for DNS
echo "192.168.30.30 chef-server.labs.in chef-server" >> /etc/hosts
echo "192.168.30.40 chef-client.labs.in chef-client" >> /etc/hosts

echo "Successfully provisioned Chef Server Standalove"
