#!/bin/bash
# 
# Script to Install Puppet Master on Single Node
#
# By: Rafael Silva

# Download the package mananger for Debian Jessie
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb

# Installing the puppet repository configuration package
dpkg -i puppetlabs-release-pc1-jessie.deb

# Update The repository
apt-get update && apt-get install puppetmaster-passenger  -y

# Housecleaning
if [ -f puppetlabs-release-pc1-jessie.deb ]; then 
	rm -f puppetlabs-release-pc1-jessie.deb
fi
