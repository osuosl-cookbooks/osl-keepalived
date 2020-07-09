#
# Cookbook:: keepalived_test
# Recipe:: eth1
#
# Copyright:: 2018-2020, Oregon State University
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

execute 'enable-dummy-nics' do
  command 'modprobe dummy numdummies=1'
end

execute 'create-fake-eth1' do
  command 'ip link set name eth1 dev dummy0'
  not_if 'ip a show dev eth1'
end

execute "add-ip-#{node['keepalived_test']['eth1']['ipv4']}" do
  command "ip addr add #{node['keepalived_test']['eth1']['ipv4']} dev eth1"
  not_if "ip a show dev eth1 | grep #{node['keepalived_test']['eth1']['ipv4']}"
end

if node['keepalived_test']['eth1']['ipv6']
  execute "add-ip-#{node['keepalived_test']['eth1']['ipv6']}" do
    command "ip addr add #{node['keepalived_test']['eth1']['ipv6']} dev eth1"
    not_if "ip a show dev eth1 | grep #{node['keepalived_test']['eth1']['ipv6']}"
  end
end

execute 'set-eth1-multicast' do
  command 'ip link set eth1 multicast on'
  not_if 'ip a show dev eth1 | grep MULTICAST'
end

execute 'set-eth1-up' do
  command 'ip link set dev eth1 up'
  not_if 'ip a show dev eth1 | grep UP'
end
