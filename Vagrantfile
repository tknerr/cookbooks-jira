# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "ubuntu-12.04-server-amd64-vagrant"
  config.vm.box_url = "W:\\boxes\\ubuntu-12.04-server-amd64-vagrant.box"

  config.vm.customize ["modifyvm", :id, "--memory", "2048"]
  config.vm.customize ["modifyvm", :id, "--cpus", "2"]
  config.vm.customize ["modifyvm", :id, "--name", "JIRA"] 

  config.vm.network :hostonly, "192.168.33.13"
  config.vm.host_name = "camp-jira"
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ".."
    #chef.data_bags_path = "..\\..\\my-chef-repo\\data_bags"
    chef.add_recipe "vagrant-ohai"
    chef.add_recipe "jira"
    chef.json = {
      :jira => {
        :database_user => 'jira',
        :database_password => 'topsecret'
      },
      :mysql => {
        :bind_address => '127.0.0.1',
        :server_root_password => 'woohoo'
      }
    }
  end
end
