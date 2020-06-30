resource "openstack_networking_network_v2" "keepalived_openstack_network" {
    name            = "keepalived_openstack_network"
    admin_state_up  = "true"
}

resource "openstack_networking_subnet_v2" "keepalived_openstack_subnet" {
    network_id      = "${openstack_networking_network_v2.keepalived_openstack_network.id}"
    cidr            = "192.168.60.0/24"
    enable_dhcp     = "false"
    no_gateway      = "true"
}

resource "openstack_networking_port_v2" "keepalived_node1_port" {
    network_id            = "${openstack_networking_network_v2.keepalived_openstack_network.id}"
    admin_state_up        = "true"
    port_security_enabled = "false"
    fixed_ip {
        subnet_id  = "${openstack_networking_subnet_v2.keepalived_openstack_subnet.id}"
        ip_address = "192.168.60.11"
    }
}

resource "openstack_networking_port_v2" "keepalived_node2_port" {
    network_id            = "${openstack_networking_network_v2.keepalived_openstack_network.id}"
    admin_state_up        = "true"
    port_security_enabled = "false"
    fixed_ip {
        subnet_id  = "${openstack_networking_subnet_v2.keepalived_openstack_subnet.id}"
        ip_address = "192.168.60.12"
    }
}

resource "openstack_compute_instance_v2" "chef_zero" {
    name            = "chef-zero"
    image_name      = "${var.centos_atomic_image}"
    flavor_name     = "m1.small"
    key_pair        = "${var.ssh_key_name}"
    security_groups = ["default"]
    connection {
        user = "centos"
    }
    network {
        uuid = "${data.openstack_networking_network_v2.network.id}"
    }
    provisioner "remote-exec" {
        inline = [
            "until [ -S /var/run/docker.sock ] ; do sleep 1 && echo 'docker not started...' ; done",
            "sudo docker run -d -p 8889:8889 --name chef-zero osuosl/chef-zero"
        ]
    }
    provisioner "local-exec" {
        command = "rake knife_upload"
        environment = {
            CHEF_SERVER = "${openstack_compute_instance_v2.chef_zero.network.0.fixed_ip_v4}"
        }
    }
}

resource "openstack_compute_instance_v2" "node1" {
    name            = "node1"
    image_name      = "${var.centos_image}"
    flavor_name     = "m1.medium"
    key_pair        = "${var.ssh_key_name}"
    security_groups = ["default"]
    connection {
        user = "centos"
    }
    network {
        uuid = "${data.openstack_networking_network_v2.network.id}"
    }
    network {
        port = "${openstack_networking_port_v2.keepalived_node1_port.id}"
    }
    provisioner "chef" {
        client_options  = ["chef_license 'accept'"]
        run_list        = ["recipe[keepalived_test::provisioning]"]
        node_name       = "node1"
        secret_key      = "${file("test/integration/encrypted_data_bag_secret")}"
        server_url      = "http://${openstack_compute_instance_v2.chef_zero.network.0.fixed_ip_v4}:8889"
        recreate_client = true
        user_name       = "fakeclient"
        user_key        = "${file("test/chef-config/fakeclient.pem")}"
        version         = "${var.chef_version}"
    }
}

resource "openstack_compute_instance_v2" "node2" {
    name            = "node2"
    image_name      = "${var.centos_image}"
    flavor_name     = "m1.medium"
    key_pair        = "${var.ssh_key_name}"
    security_groups = ["default"]
    depends_on      = ["openstack_compute_instance_v2.node1"]
    connection {
        user = "centos"
    }
    network {
        uuid = "${data.openstack_networking_network_v2.network.id}"
    }
    network {
        port = "${openstack_networking_port_v2.keepalived_node2_port.id}"
    }
    provisioner "chef" {
        client_options  = ["chef_license 'accept'"]
        run_list        = ["recipe[keepalived_test::provisioning]"]
        node_name       = "node2"
        secret_key      = "${file("test/integration/encrypted_data_bag_secret")}"
        server_url      = "http://${openstack_compute_instance_v2.chef_zero.network.0.fixed_ip_v4}:8889"
        recreate_client = true
        user_name       = "fakeclient"
        user_key        = "${file("test/chef-config/fakeclient.pem")}"
        version         = "${var.chef_version}"
    }
}
