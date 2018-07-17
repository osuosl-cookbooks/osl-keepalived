node.override['firewall']['vrrp']['range']['4'] = %w(192.168.60.10/24)
node.override['firewall']['vrrp']['range']['6'] = %w(fc00::/64)

include_recipe 'firewall::default'
include_recipe 'firewall::http'

node.default['osl-keepalived']['master'] = {
  'node1' => true,
  'node2' => false
}

node.default['osl-keepalived']['priority'] = {
  'node1' => 200,
  'node2' => 100
}

include_recipe 'osl-keepalived::default'

osl_ifconfig "192.168.60.#{node['keepalived_test']['ip']}" do
  onboot 'yes'
  mask '255.255.255.0'
  network '192.168.60.0'
  ipv6init 'yes'
  ipv6addr "fc00::#{node['keepalived_test']['ip']}"
  device 'enp0s8'
end

keepalived_vrrp_instance 'default_ipv4' do
  master node['osl-keepalived']['master'][node['fqdn']]
  interface 'enp0s8'
  virtual_router_id 1
  priority node['osl-keepalived']['priority'][node['fqdn']]
  authentication auth_type: 'PASS', auth_pass: 'password'
  virtual_ipaddress %w(192.168.60.10/24)
  notifies :restart, 'service[keepalived]'
end

keepalived_vrrp_instance 'default_ipv6' do
  master node['osl-keepalived']['master'][node['fqdn']]
  interface 'enp0s8'
  virtual_router_id 2
  priority node['osl-keepalived']['priority'][node['fqdn']]
  # Authentication isn't actually used with IPv6 (see https://tools.ietf.org/html/rfc5798#section-9)
  # however, keepalived cookbook requires this to be defined
  authentication auth_type: 'PASS', auth_pass: 'password'
  virtual_ipaddress %w(fc00::10/64)
  notifies :restart, 'service[keepalived]'
end

keepalived_vrrp_sync_group 'default_group' do
  group %w(default_ipv4 default_ipv6)
end

# Simple http server for testing location of VIP
package 'httpd'

service 'httpd' do
  action [:enable, :start]
end

file '/usr/share/httpd/noindex/index.html' do
  content "#{node['fqdn']}\n"
end
