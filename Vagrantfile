Vagrant.configure(2) do |config|
	config.vm.box = "debian/bookworm64"
  
	config.vm.provision "ansible" do |ansible|
		ansible.verbose = "v"
		ansible.playbook = "playbook/install_packages.yml"
	end
  end