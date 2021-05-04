#
# Cookbook:: keepalived_test
# Recipe:: eth1
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

i = 0

node['keepalived_test']['interfaces'].each do |int|
  osl_fakenic int['name'] do
    ip4 int['ipv4']
    ip6 int['ipv6'] if int['ipv6']
    multicast true
  end
  i += 1
end
