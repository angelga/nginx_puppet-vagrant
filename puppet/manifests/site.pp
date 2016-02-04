# Install the nginx package
package { 'nginx':
    ensure => latest
}

# Make sure service is running
service { 'nginx':
    ensure => running,
    require => Package['nginx'],
}

# Add a vhost template
file { 'vagrant-nginx':
    path => '/etc/nginx/sites-available/puppet.technical.assessment.conf',
    ensure => file,
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/puppet.technical.assessment.conf',
}

# Disable the default nginx vhost
file { 'default-nginx-disable':
    path => '/etc/nginx/sites-enabled/default',
    ensure => absent,
    require => Package['nginx'],
}

# Symlink our vhost in sites-enabled to enable it
file { 'vagrant-nginx-enable':
    path => '/etc/nginx/sites-enabled/puppet.technical.assessment.conf',
    target => '/etc/nginx/sites-available/puppet.technical.assessment.conf',
    ensure => link,
    notify => Service['nginx'],
    require => [
        File['vagrant-nginx'],
        File['default-nginx-disable'],
    ],
}
