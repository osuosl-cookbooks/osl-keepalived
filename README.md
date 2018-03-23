osl-keepalived Cookbook
=======================
This is OSL's wrapper cookbook for utilizing the [keepalived cookbook](https://supermarket.chef.io/cookbooks/keepalived).

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any
requirements this cookbook has on platforms, libraries, other cookbooks,
packages, operating systems, etc.

#### Cookbooks
- `keepalived` - the upstream cookbook that this wraps

Attributes
----------
### osl-keepalived::haproxy-osuosl

Key                                                         | Type              | Description                                            | Default
----------------------------------------------------------- | -------           | ------------------------------------------------------ | -------
`['osl-keepalived']['haproxy-osuosl']['master']`            | Boolean           | whether the node should default to be master or backup | `false`
`['osl-keepalived']['haproxy-osuosl']['priority']`          | Integer           | priority value for inheriting master (greater wins)    | 100
`['osl-keepalived']['haproxy-osuosl']['auth_pass']`         | String            | password for VRRP authentication                       | nil
`['osl-keepalived']['haproxy-osuosl']['virtual_ipaddress']` | List of Strings   | list of IPs that will fail over                        | 140.211.9.53


e.g.
#### osl-keepalived::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['osl-keepalived']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### osl-keepalived::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `osl-keepalived` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[osl-keepalived]"
  ]
}
```

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
