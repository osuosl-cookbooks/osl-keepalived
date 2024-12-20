#
# Cookbook:: osl-keepalived
# Recipe:: mysql
#
# Copyright:: 2018-2024, Oregon State University
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

node.default['osl-keepalived']['primary'] = {
  'mysql1.osuosl.org' => true,
  'mysql2.osuosl.org' => false,
}

node.default['osl-keepalived']['priority'] = {
  'mysql1.osuosl.org' => 200,
  'mysql2.osuosl.org' => 100,
}

include_recipe 'osl-keepalived::default'

secrets = data_bag_item('osl_keepalived', 'mysql_vip1')

keepalived_vrrp_instance 'mysql-ipv4' do
  master node['osl-keepalived']['primary'][node['fqdn']]
  interface node['osl-keepalived']['haproxy']['interface']
  virtual_router_id 7
  priority node['osl-keepalived']['priority'][node['fqdn']]
  authentication auth_type: 'PASS', auth_pass: secrets['auth_pass']
  virtual_ipaddress %w(140.211.15.221/24)
  notifies :reload, 'service[keepalived]'
end

service 'keepalived' do
  action [:enable, :start]
end
