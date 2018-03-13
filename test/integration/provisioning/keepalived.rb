require 'chef/provisioning'
require 'chef/provisioning/vagrant_driver'

with_driver "vagrant:#{File.dirname(__FILE__)}/../../../vms"

[%w(node1 11), %w(node2 12)].each do |name, ip_suff|
  machine name do
    machine_options vagrant_options: {
      'vm.box' => 'bento/centos-7.4'
    },
                    convergence_options: {
                      chef_version: '12.18.31'
                    }
    add_machine_options vagrant_config: <<-EOF
    config.vm.network "private_network", ip: "192.168.60.#{ip_suff}"
EOF
    recipe 'keepalived_test::provisioning'
    file('/etc/chef/encrypted_data_bag_secret',
         File.dirname(__FILE__) +
         '/../encrypted_data_bag_secret')
    converge true
  end
end
