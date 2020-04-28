require_relative './fake_interface.rb'

make_dummy('eth1', node['keepalived_test']['eth1']['ipv4'], node['keepalived_test']['eth1']['ipv6'])
