#
# Cookbook:: osl-keepalived
# Recipe:: mysql
#
# Copyright:: 2018-2025, Oregon State University
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

include_recipe 'osl-keepalived::default'

secrets = data_bag_item('osl_keepalived', 'mysql_vip2')

keepalived_vrrp_instance 'mysql-ipv4' do
  master true
  interface node['osl-keepalived']['default_interface']
  nopreempt true
  virtual_router_id 5
  priority 100
  authentication auth_type: 'PASS', auth_pass: secrets['auth_pass']
  virtual_ipaddress %w(140.211.9.47/24)
  notifies :reload, 'service[keepalived]'
end

keepalived_vrrp_instance 'mysql-backend-ipv4' do
  master true
  interface 'eno2'
  nopreempt true
  virtual_router_id 6
  priority 100
  authentication auth_type: 'PASS', auth_pass: secrets['auth_pass']
  virtual_ipaddress %w(10.1.0.86/23)
  notifies :reload, 'service[keepalived]'
end

service 'keepalived' do
  action [:enable, :start]
end
