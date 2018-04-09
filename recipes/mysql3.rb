#
# Cookbook:: osl-keepalived
# Recipe:: mysql3
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

mysql = node['osl-keepalived']['mysql']

keepalived_vrrp_instance 'mysql3' do
  master true
  interface node['network']['default_interface']
  virtual_router_id 3
  priority 200
  authentication auth_type: 'PASS', auth_pass: mysql['auth_pass']
  virtual_ipaddress mysql['virtual_ipaddress']
end
