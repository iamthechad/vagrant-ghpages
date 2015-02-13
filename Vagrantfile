# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/debian-7.7"

  config.vm.network "forwarded_port", guest: 4000, host: 4000

  config.vm.synced_folder "www/", "/opt/ghpages", create: true

  config.vm.provider "virtualbox" do |vb|
       # Don't boot with headless mode
        #   vb.gui = true

       # Use VBoxManage to customize the VM. For example to change memory:
       vb.customize ["modifyvm", :id, "--memory", "4096"]
       vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provider "parallels" do |v, override|
       override.vm.box = "parallels/debian-7.7"
       v.name = "OpenVAS - Vagrant"
       v.memory = 4096
       v.cpus = 2
  end

  config.vm.provision "shell", path: "manifests/puppet.sh", privileged: false
  config.vm.provision :puppet

  if Vagrant.has_plugin?("vagrant-triggers")
      config.trigger.after :destroy do
        run "rm -Rf www"
      end
  end
end
