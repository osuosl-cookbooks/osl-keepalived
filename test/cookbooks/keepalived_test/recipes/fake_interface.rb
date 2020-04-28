#
# Cookbook:: keepalived_test
# Recipe:: eth1
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

def make_dummy(interface, ipv4, ipv6 = nil)
  @dum ||= 0
  execute 'enable-dummy-nics' do
    command 'modprobe dummy numdummies=2'
  end

  temp = @dum
  execute "create-fake-#{interface}" do
    command "ip link set name #{interface} dev dummy#{temp}"
    not_if "ip a show dev #{interface}"
  end
  @dum += 1

  execute "add-ip-#{ipv4}" do
    command "ip addr add #{ipv4} dev #{interface}"
    not_if "ip a show dev #{interface} | grep #{ipv4}"
  end

  if ipv6
    execute "add-ip-#{ipv6}" do
      command "ip addr add #{ipv6} dev #{interface}"
      not_if "ip a show dev #{interface} | grep #{ipv6}"
    end
  end

  execute "set-#{interface}-multicast" do
    command "ip link set #{interface} multicast on"
    not_if "ip a show dev #{interface} | grep MULTICAST"
  end

  execute "set-#{interface}-up" do
    command "ip link set dev #{interface} up"
    not_if "ip a show dev #{interface} | grep UP"
  end
end
