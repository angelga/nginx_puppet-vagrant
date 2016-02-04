#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
    echo "Script must be run as root." >&2
    exit 1
fi

update_needed=true
# Install puppet
if [ $(command -v puppet) >/dev/null 2>&1 ]; then
    echo "Puppet is already installed"
else
    echo "Installing Puppet repo for Ubuntu 12.04 LTS"
    wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
    dpkg -i puppetlabs-release-precise.deb
    rm puppetlabs-release-precise.deb
    update_needed=false
    apt-get update
    apt-get install -y puppet
fi

# Install git
if [ $(command -v git) >/dev/null 2>&1 ]; then
    echo "Git already installed"
else
    echo "Installing git"
    if [ "$update_needed" = true ]; then
        apt-get update
    fi
    apt-get install -y git
fi

echo "Make root site dir"
mkdir -p /var/www/puppet/html

echo "Clone site repo"
if [ ! -d ~/html ]; then
    git clone https://github.com/puppetlabs/exercise-webpage ~/html
else
    cd ~/html
    git pull
fi
if [ $(find ~/html -type f -iname "index.*" | wc -l) -gt 0 ]; then
    echo "Github repo cloned/pulled correctly"
else
    echo "Error pulling github repo"
    exit 1
fi
rsync -r --exclude=".*"  ~/html/ /var/www/puppet/html

# Check everything is configured correctly
if [ $(command -v puppet) >/dev/null 2>&1 ]; then
    echo "Puppet installed correctly"
else
    echo "Puppet not installed correctly"
    exit 1
fi

if [ $(command -v git) >/dev/null 2>&1 ]; then
    echo "Git installed correctly"
else
    echo "Git not installed correctly"
    exit 1
fi

echo "Bootstrap.sh completed"
