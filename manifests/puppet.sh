#!/bin/sh

echo "Installing puppet"
puppet_version="$(dpkg -s puppet 2>&1 | grep 'Version:' | cut -d " " -f 2)"
if [ ! -n "${puppet_version}" ]
    then
        # We need version 3 of Puppet, so need to add that repo
        wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -O /tmp/puppetlabs-release-trusty.deb

        if [ ! -e '/tmp/puppetlabs-release-trusty.deb' ]
            then
                echo "Unable to download puppetlabs repository definition. Cannot continue"
                exit 1
        fi
        sudo dpkg -i /tmp/puppetlabs-release-trusty.deb
        sudo apt-get update

        sudo apt-get -y install puppet
fi

echo "Install vcsrepo module"
if sudo puppet module list | grep -q vcsrepo
    then echo "vcsrepo module already installed"
    else sudo puppet module install puppetlabs-vcsrepo
fi

echo "Install rvm module"
if sudo puppet module list | grep -q rvm
    then echo "rvm module already installed"
    else
        sudo puppet module install maestrodev/rvm
        # RVM 1.26 and higher check signatures, but the module doesn't support that yet
        sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
fi

echo "Install nodejs module"
if sudo puppet module list | grep -q nodejs
    then echo "nodejs module already installed"
    else sudo puppet module install willdurand/nodejs
fi