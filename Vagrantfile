# 3AX.ORG Default Vagrant VM Configuration
#
# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
# @see         LICENSE for license

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/vivid64"

    config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    config.vm.network "forwarded_port", guest: 443, host: 4443, auto_correct: true
    config.vm.network "forwarded_port", guest: 5432, host: 55432, auto_correct: true

    config.vm.synced_folder "./Vagrant", "/vagrant", owner: "root", group: "root"
    config.vm.synced_folder "./Project", "/var/www/project", owner: "www-data", group: "www-data"
    config.vm.synced_folder "./Tool", "/var/www/tool", owner: "www-data", group: "www-data"
    config.vm.synced_folder "./Test", "/var/www/test", owner: "www-data", group: "www-data"

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "512"]
    end

    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update -y
        sudo apt-get upgrade -y
        sudo apt-get install -y curl git openssl
    SHELL

    config.vm.provision "shell", path: "./Vagrant/init.sh"

    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get autoremove -y > /dev/null
        sudo apt-get autoclean -y > /dev/null
    SHELL
end
