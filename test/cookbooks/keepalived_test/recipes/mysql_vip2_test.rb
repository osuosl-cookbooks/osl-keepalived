node.default['keepalived_test']['interfaces'] = [
  { 'name': 'eno1', 'ipv4': '140.211.9.50/24' },
  { 'name': 'eno2', 'ipv4': '140.211.9.50/24' },
]

include_recipe 'keepalived_test::fake_int'
