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
# Check puppet is installed correctly
if [ $(command -v puppet) >/dev/null 2>&1 ]; then
    echo "Puppet installed correctly"
else
    echo "Puppet not installed correctly"
    exit 1
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
# Check git is installed correctly
if [ $(command -v git) >/dev/null 2>&1 ]; then
    echo "Git installed correctly"
else
    echo "Git not installed correctly"
    exit 1
fi

echo "Make root site dir"
www_root='/var/www/puppet/html'
mkdir -p $www_root
if [ ! -d $www_root ]; then
    echo "Can't make target directy $www_root"
    exit 1
fi

echo "Clone site repo"
repo_destination=~/html
if [ ! -d $repo_destination ]; then
    git clone https://github.com/puppetlabs/exercise-webpage $repo_destination
else
    cd $repo_destination
    git pull
fi
if [ $(find $repo_destination -type f -iname "index.*" | wc -l) -gt 0 ]; then
    echo "Github repo cloned/pulled correctly"
else
    echo "Error pulling github repo"
    exit 1
fi

# Copy github repo to target
repo_destination="$repo_destination/"
rsync -r --exclude=".*"  $repo_destination $www_root
if [ $(find $www_root -type f -iname "index.*" | wc -l) -eq 0 ]; then
    echo "Error copying repo contents to target dir"
    exit 1
fi

echo "Bootstrap.sh completed"
