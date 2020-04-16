default['keepalived_test']['ip'] = node['fqdn'].start_with?('node1') ? 11 : 12
