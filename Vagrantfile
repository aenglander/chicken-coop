Vagrant::configure("2") do |config|
  config.vm.box = "chicken-coop-dev"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "coop.dev"

  config.vm.provider :virtualbox do |vb|
    vb.name = "chicken-coop-dev"
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 80, host: 8080 #http
  config.vm.network :forwarded_port, guest: 443, host: 4443 #https
  config.vm.network :forwarded_port, guest: 27017, host: 27017 #mongo
  config.vm.network :forwarded_port, guest: 15672, host: 15672 #rabbitmq-admin

  config.vm.network :private_network, ip: "10.1.0.3"

  config.vm.synced_folder "code", "/virtualhosts", :nfs => true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe("op")
    chef.add_recipe("nginx")
    chef.add_recipe("php")
    chef.add_recipe("op::mongo")
    chef.add_recipe("op::rabbitmq")
    chef.add_recipe("op::php")
    chef.add_recipe("op::coupla-site")
    chef.add_recipe("op::java")

    chef.json = {
        "php" => {
            "packages" => ['php5', 'php5-fpm', 'php5-cli', 'php-pear', 'php5-dev', 'php5-curl', 'php5-xdebug'],
            "directives" => {
                "date.timezone" => "America/Los_Angeles"
            }
        }
    }
  end
end
