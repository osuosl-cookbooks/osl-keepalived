output "chef_zero" {
    value = "${openstack_compute_instance_v2.chef_zero.network.0.fixed_ip_v4}"
}
output "node1" {
    value = "${openstack_compute_instance_v2.node1.network.0.fixed_ip_v4}"
}
output "node2" {
    value = "${openstack_compute_instance_v2.node2.network.0.fixed_ip_v4}"
}
