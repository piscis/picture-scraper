# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box_url = "https://107e82132ac6bab83e2b-82ed2133087df3e64a5a7e3897d99395.ssl.cf5.rackcdn.com/picture-scraper-v1.0.2.box"
  config.vm.box = "picture-scraper-v1.0.2"

  # Use vagrant-omnibus to install chef client
  config.omnibus.chef_version = :latest

  config.vm.network :public_network, :use_dhcp_assigned_default_route => true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #config.vm.network :private_network, ip: "192.168.33.23"

  config.ssh.forward_agent = true

  config.vm.synced_folder ".", "/home/vagrant/picture-scraper"

  config.vm.hostname = "picture-scrape.local"

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1048"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

end
