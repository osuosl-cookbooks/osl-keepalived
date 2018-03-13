osl-keepalived Cookbook
=======================
This is OSL's wrapper cookbook for utilizing the [keepalived cookbook](https://supermarket.chef.io/cookbooks/keepalived).

Requirements
------------

#### Platforms
- CentOS 7

#### Cookbooks
- `keepalived` - the upstream cookbook that this is wrapping
- `firewall` - our internal firewall cookbook has a recipe for VRRP rules

Attributes
----------

Key                                    | Description
-------------------------------------- | -------------------------------
`['osl-keepalived']['default_master']` | FQDN of the default master node

Usage
-----
A single recipe exists for each group of hosts sharing a virtual IP (i.e.
`osl-keepalived::haproxy-osuosl` is for `lb1.osuosl.org` and `lb2.osuosl.org`
sharing the IP for `vip-lb1.osuosl.org`). This recipe should be converged on
each of these hosts.

Testing
-------
In addition to Kitchen and ChefSpec, chef-provisioning can be used to test
failover between two VMs (as this is difficult to do with Kitchen). First, set
up the VMs with `rake keepalived`. Then `cd vms/` and connect to the nodes with
`vagrant ssh node1` and `vagrant ssh node2`. Each node is running an HTTP
server that serves its hostname, so you can curl the virtual IPs to determine
which is the current master:

* `curl 192.168.60.10`
* `curl -g -6 http://[fc00::10]`

To test failover, you can do `systemctl stop keepalived` on the master node, and
then curl again.

When you're finished with these VMs, be sure to run `rake clean`.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `username/add_component_x`)
3. Write tests for your change
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
- Author:: Oregon State University <chef@osuosl.org>

```text
Copyright:: 2018, Oregon State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
