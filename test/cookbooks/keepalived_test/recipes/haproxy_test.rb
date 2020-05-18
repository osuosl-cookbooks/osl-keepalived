node.default['keepalived_test']['interfaces'] = [
  { 'name': 'eth1', 'ipv4': '140.211.9.50/24', 'ipv6': '2605:bc80:3010:104::8cd3:935/64' },
]

include_recipe 'keepalived_test::fake_int'
