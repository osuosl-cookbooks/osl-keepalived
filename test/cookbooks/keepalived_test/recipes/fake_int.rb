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
  command "modprobe dummy numdummies=#{node['keepalived_test']['interfaces'].length}"
  only_if { node['kernel']['modules']['dummy'].nil? }
end

i = 0
node['keepalived_test']['interfaces'].each do |int|
  execute "create-fake-#{int['name']}" do
    command "ip link set name #{int['name']} dev dummy#{i}"
    not_if "ip a show dev #{int['name']}"
  end

  execute "add-ip-#{int['name']}" do
    command "ip addr add #{int['ipv4']} dev #{int['name']}"
    not_if "ip a show dev #{int['name']} | grep #{int['ipv4']}"
  end
  if int['ipv6']
    execute "add-ip-#{int['ipv6']}" do
      command "ip addr add #{int['ipv6']} dev #{int['name']}"
      not_if "ip a show dev #{int['name']} | grep #{int['ipv6']}"
    end
  end

  execute "set-#{int}-multicast" do
    command "ip link set #{int['name']} multicast on"
    not_if "ip a show dev #{int['name']} | grep MULTICAST"
  end

  execute "set-#{int['name']}-up" do
    command "ip link set dev #{int['name']} up"
    not_if "ip a show dev #{int['name']} | grep UP"
  end
  i += 1
end
