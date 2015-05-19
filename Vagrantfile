# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Everybody else uses Ubuntu, but I like Debian
  config.vm.box = "chef/debian-7.7"

  # Forward the Jekyll port
  config.vm.network "forwarded_port", guest: 4000, host: 4000

  # Sync a folder on the host to where the code will be checked out in the guest
  config.vm.synced_folder "ghpages/", "/opt/ghpages", create: true

  config.vm.provider "virtualbox" do |vb|
       # Use VBoxManage to customize the VM. For example to change memory:
       vb.name = "GitHub Pages"
       vb.customize ["modifyvm", :id, "--memory", "1024"]
       vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provider "parallels" do |v, override|
       override.vm.box = "parallels/debian-7.7"
       v.name = "GitHub Pages"
       v.memory = 1024
       v.cpus = 2
  end

  config.vm.provision "shell", path: "manifests/puppet.sh", privileged: false
  config.vm.provision :puppet, run: "always"

  # Remove local files on destroy if vagrant-triggers plugin installed
  # Probably won't work as expected on Windows boxen
  #if Vagrant.has_plugin?("vagrant-triggers")
  #    config.trigger.after :destroy do
  #      run "rm -Rf ghpages/"
  #    end
  #end
end
