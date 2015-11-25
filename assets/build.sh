#!/bin/bash
# Set noninteractive mode for apt-get
export DEBIAN_FRONTEND=noninteractive

# Update
apt-get update

# Install packages here so they're preserved in the cache
apt-get -y install supervisor postfix mpack ruby2.0 awscli mailutils

adduser filter --disabled-password --no-create-home
mkdir /var/spool/filter
chown filter:filter /var/spool/filter
