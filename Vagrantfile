Vagrant.configure(2) do |config|
	config.vm.box = "debian/bookworm64"
	
	config.ssh.insert_key = false
	config.vm.network "private_network", ip: "192.168.56.10"
	config.vm.provision "shell", inline: <<-SHELL
	echo "VM is ready. Run Ansible manually."
	SHELL
  end