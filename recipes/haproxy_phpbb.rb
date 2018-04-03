#
# Cookbook:: osl-keepalived
# Recipe:: haproxy_phpbb
#
# Copyright:: 2018, Oregon State University
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

haproxy_phpbb = node['osl-keepalived']['haproxy-phpbb']

keepalived_vrrp_instance 'vip-phpbb-lb1' do
  master haproxy_phpbb['master']
  interface node['network']['default_interface']
  virtual_router_id 2
  priority haproxy_phpbb['priority']
  authentication auth_type: 'PASS', auth_pass: haproxy_phpbb['auth_pass']
  virtual_ipaddress haproxy_phpbb['virtual_ipaddress']
end
