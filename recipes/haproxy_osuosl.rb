#
# Cookbook:: osl-keepalived
# Recipe:: haproxy-osuosl
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

haproxy_osuosl = node['osl-keepalived']['haproxy-osuosl']

keepalived_vrrp_instance 'vip-lb1' do
  master haproxy_osuosl['master']
  interface node['network']['default_interface']
  virtual_router_id 1
  priority haproxy_osuosl['priority']
  authentication auth_type: 'PASS', auth_pass: haproxy_osuosl['auth_pass']
  virtual_ipaddress haproxy_osuosl['virtual_ipaddress']
end
