# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANT_API_VERSION = "2"

instance_IP     = "192.168.35.50"
host_name       = "terraform"
box             = "ubuntu/bionic64"

Vagrant.configure(VAGRANT_API_VERSION) do |config|

  config.vm.define host_name do |instance|
    instance.vm.box = box
    instance.vm.hostname = host_name
    instance.vm.network :private_network, ip: instance_IP

    instance.vm.synced_folder ".", "/home/vagrant/src"

    instance.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 1024]
    end

    instance.vm.provision "shell", inline: <<-SCRIPT
        apt-get update -y
        # Need to set up time sync using chrony to ensure AWS login works properly
        timedatectl set-timezone Europe/London
        apt-get install unzip chrony -y
        wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
        unzip terraform_0.12.24_linux_amd64.zip
        mv terraform /usr/local/bin
        rm terraform_0.12.24_linux_amd64.zip
    SCRIPT
  end

end
