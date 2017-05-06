Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.memory = "4096"
    vb.cpus = "8"
  end
  config.vm.provision :shell, path: "provision/setup.sh"
end
