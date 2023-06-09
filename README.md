# osl-keepalived Cookbook

This is OSL's wrapper cookbook for utilizing the [keepalived cookbook](https://supermarket.chef.io/cookbooks/keepalived).

## Requirements

### Platforms

- CentOS 7
- AlmaLinux 8

### Cookbooks

- [`keepalived`](https://github.com/sous-chefs/keepalived/) - the upstream cookbook that this is wrapping
- [`osl-firewall`](https://github.com/osuosl-cookbooks/osl-firewall) - for VRRP firewall rules

## Attributes

| Key                                    | Description                     |
|----------------------------------------|---------------------------------|
| `['osl-keepalived']['primary']` | FQDN of the default master node |

## Usage

A single recipe exists for each group of hosts sharing a virtual IP (i.e. `osl-keepalived::haproxy-osuosl` is for
`lb1.osuosl.org` and `lb2.osuosl.org` sharing the IP for `vip-lb1.osuosl.org`). This recipe should be converged on each
of these hosts.

## Provisioning Environment

### Prereqs

- ChefDK 2.5.3 or later
- Terraform
- `kitchen-terraform`
- OpenStack cluster

Ensure you have the following in your `.bashrc` (or similar):

```bash
export TF_VAR_ssh_key_name="$OS_SSH_KEYPAIR"
```

### General Layout

This cookbook contains a [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform) environment that can
be used to test multi-node configurations. You can spin up this environment using `kitchen test multi-node`.

If you want to create/converge only 1 VM you can use any of these commands:

| VM    | Command                                                       |
|-------|---------------------------------------------------------------|
| node1 | `terraform apply -target openstack_compute_instance_v2.node1` |
| node2 | `terraform apply -target openstack_compute_instance_v2.node2` |

You can login to a VM by using one of these commands:

```bash
$ ssh centos@$(terraform output node1)
$ ssh centos@$(terraform output node2)
```

When you are done testing the provisioning environment run ``kitchen destroy multi-node``.

Here is a table showing what each IP points to:

| Host  | IP              |
|-------|-----------------|
| VIP   | `192.168.60.10` |
| node1 | `192.168.60.11` |
| node2 | `192.168.60.12` |

### Interacting with the chef-zero server

All of these nodes are configured using a Chef Server which is a container running chef-zero. You can interact with the
chef-zero server by doing the following:

```bash
$ CHEF_SERVER="$(terraform output chef_zero)" knife node list -c test/chef-config/knife.rb
node1
node2
```

In addition, on any node that has been deployed, you can re-run ``chef-client`` like you normally would on a production
system. This should allow you to do development on your multi-node environment as needed. **Just make sure you include
the knife config otherwise you will be interacting with our production Chef server!**

### Using Terraform directly

You do not need to use kitchen-terraform directly if you're just doing development. It's primarily useful for testing
the multi-node cluster using Inspec. You can simply deploy the cluster using terraform directly by doing the following:

```bash
# Sanity check
$ terraform plan
# Deploy the cluster
$ terraform apply
# Destroy the cluster
$ terraform destroy
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `username/add_component_x`)
3. Write tests for your change
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

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
