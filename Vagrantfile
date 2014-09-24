require 'yaml'

# Looking at a credentail file as opposed to having it in the config file
RS_CONFIG = YAML.load_file(ENV['HOME']+'/.rax_cred_file')
RS_USER = RS_CONFIG['rackspace']['user']
RS_KEY = RS_CONFIG['rackspace']['api_key']
RS_REGION = RS_CONFIG['rackspace']['region']
RS_NETWORK = RS_CONFIG['rackspace']['network']
PUBLIC_KEY = RS_CONFIG['ssh']['public']
PRIVATE_KEY = RS_CONFIG['ssh']['private']

# Setting a shell variable to default to Rackspace as the provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'rackspace'

Vagrant.configure("2") do |config|
    config.vm.box = "tct-rax"
    config.ssh.pty = true
    config.ssh.private_key_path = PRIVATE_KEY

    config.vm.define "storage" do |stroage|
        config.vm.provider :rackspace do |storage|
            storage.server_name = "storage"
            storage.username = RS_USER
            storage.api_key = RS_KEY
            storage.flavor = /512MB/
            storage.image = /^CentOS 6.5$/
            storage.rackspace_region = "ord"
            storage.public_key_path = PUBLIC_KEY
            storage.network RS_NETWORK
        end
        config.vm.provision "shell", path: "env-setup.sh"
    end

    config.vm.define "node1" do |node1|
        config.vm.provider :rackspace do |node1|
            node1.server_name = "node1"
            node1.username = RS_USER
            node1.api_key = RS_KEY
            node1.flavor = /512MB/
            node1.image = /^CentOS 6.5$/
            node1.rackspace_region = "ord"
            node1.public_key_path = PUBLIC_KEY
            node1.network RS_NETWORK
        end

        config.vm.provision "shell", path: "env-setup.sh"

    end
    config.vm.define "node2" do |node2|
        config.vm.provider :rackspace do |node2|
            node2.server_name = "node2"
            node2.username = RS_USER
            node2.api_key = RS_KEY
            node2.flavor = /512MB/
            node2.image = /^CentOS 6.5$/
            node2.rackspace_region = "ord"
            node2.public_key_path = PUBLIC_KEY
            node2.network RS_NETWORK
        end
        config.vm.provision "shell", path: "env-setup.sh"
    end
end
