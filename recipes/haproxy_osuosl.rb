#
# Cookbook:: osl-keepalived
# Recipe:: haproxy-osuosl
#
# Copyright:: 2018-2021, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.default['osl-keepalived']['master'] = {
  'lb1.osuosl.org' => true,
  'lb2.osuosl.org' => false,
}

node.default['osl-keepalived']['priority'] = {
  'lb1.osuosl.org' => 200,
  'lb2.osuosl.org' => 100,
}

include_recipe 'osl-keepalived::default'

secrets = data_bag_item('osl_keepalived', 'haproxy_osuosl')

keepalived_vrrp_instance 'haproxy-osuosl-ipv4' do
  master node['osl-keepalived']['master'][node['fqdn']]
  interface node['osl-keepalived']['haproxy']['interface']
  virtual_router_id 1
  priority node['osl-keepalived']['priority'][node['fqdn']]
  authentication auth_type: 'PASS', auth_pass: secrets['auth_pass']
  virtual_ipaddress %w(140.211.9.53/24)
  notifies :reload, 'service[keepalived]'
end

keepalived_vrrp_instance 'haproxy-osuosl-ipv6' do
  master node['osl-keepalived']['master'][node['fqdn']]
  interface node['osl-keepalived']['haproxy']['interface']
  virtual_router_id 2
  priority node['osl-keepalived']['priority'][node['fqdn']]
  # Authentication isn't actually used with IPv6 (see https://tools.ietf.org/html/rfc5798#section-9)
  # however, keepalived cookbook requires this to be defined
  authentication auth_type: 'PASS', auth_pass: secrets['auth_pass']
  virtual_ipaddress %w(2605:bc80:3010:104::8cd3:935/64)
  notifies :reload, 'service[keepalived]'
end

# Sync group ensures IPv4 and IPv6 fail over together
keepalived_vrrp_sync_group 'haproxy-osuosl-group' do
  group %w(haproxy-osuosl-ipv4 haproxy-osuosl-ipv6)
  notifies :reload, 'service[keepalived]'
end
