# Technical assessment for Puppet Labs

## Goal

Using Puppet:

- Configure nginx server
- Serving at port 8000
- Serve page with content from https://github.com/puppetlabs/exercise-webpage

## Assumptions

- You are running from a \*nix machine. I tested this with OSX El Capitan.
- You have Vagrant and git installed

## Notes

- Performed exercise on Ubuntu 12.04 using image from http://puppet-vagrant-boxes.puppetlabs.com/
- Port was forwarded to host's port 8080
- To test from host, browse http://localhost:8080
- To test from guest run from bash: `curl http://localhost:8000`
