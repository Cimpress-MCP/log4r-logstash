# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
apt-get update
apt-get install -y redis-server
sed -i '/bind 127.0.0.1/c\\#bind 127.0.0.1' /etc/redis/redis.conf
service redis-server restart
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.network :forwarded_port, host: 6379, guest: 6379
  config.vm.provision "shell", inline: $script
  config.vm.box = "ubuntu/trusty64"
end
