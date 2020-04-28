require_relative './fake_interface.rb'

make_dummy('eth1', node['keepalived_test']['eth1']['ipv4'])

make_dummy('eth2', node['keepalived_test']['eth2']['ipv4'])
