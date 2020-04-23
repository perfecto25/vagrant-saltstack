# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  os = "centos/7"
  net_ip = "192.168.97"

  config.vm.define :devsaltmaster, primary: true do |master_config|
    master_config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 1
        vb.name = "devsaltmaster"
    end
    
    master_config.vm.box = "#{os}"
    master_config.vm.host_name = 'devsaltmaster'
    master_config.vm.network "private_network", ip: "#{net_ip}.10"
    master_config.vm.synced_folder "saltstack/salt/", "/srv/salt"
    master_config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"
    
    
    master_config.vm.provision :shell, path: "provision.sh"
    
    master_config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
          mkdir /root/.ssh
          touch /root/.ssh/authorized_keys
          chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
          yum -y install salt-master
      SHELL
    end

    master_config.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/devsaltmaster"
      salt.master_key = "saltstack/keys/master_minion.pem"
      salt.master_pub = "saltstack/keys/master_minion.pub"
      salt.minion_key = "saltstack/keys/master_minion.pem"
      salt.minion_pub = "saltstack/keys/master_minion.pub"
      salt.seed_master = {
                          "min1" => "saltstack/keys/min1.pub",
                          "min2" => "saltstack/keys/min2.pub"
                         }

      salt.install_master = false
      salt.no_minion = true
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
    

  end


  [
    ["min1",    "#{net_ip}.11",    "1024",    "centos/7" ],
    ["min2",    "#{net_ip}.12",    "1024",    "centos/7" ]
  ].each do |vmname,ip,mem,os|
    config.vm.define "#{vmname}" do |minion_config|
      minion_config.vm.provider "virtualbox" do |vb|
          vb.memory = "#{mem}"
          vb.cpus = 1
          vb.name = "#{vmname}"
      end

      minion_config.vm.box = "#{os}"
      minion_config.vm.hostname = "#{vmname}"
      minion_config.vm.network "private_network", ip: "#{ip}"
      
      minion_config.vm.provision :shell, path: "provision.sh"
      minion_config.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
        s.inline = <<-SHELL
            mkdir /root/.ssh
            touch /root/.ssh/authorized_keys
            chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
            echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
            echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
            echo "192.168.97.10 devsaltmaster" >> /etc/hosts
            yum -y install salt-minion
        SHELL
      end 
      
      minion_config.vm.provision :salt do |salt|
        salt.minion_config = "saltstack/etc/#{vmname}"
        salt.minion_key = "saltstack/keys/#{vmname}.pem"
        salt.minion_pub = "saltstack/keys/#{vmname}.pub"
        salt.verbose = true
        salt.colorize = true
        salt.bootstrap_options = "-P -c /tmp"
      end
      
    end
  end


end  # initial
