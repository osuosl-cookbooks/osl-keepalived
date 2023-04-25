node.default['keepalived_test']['interfaces'] = [
  { 'name': 'eth1', 'ipv4': '140.211.15.175/24' },
]

include_recipe 'keepalived_test::fake_int'
