describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__mysql-ipv4__.conf' do
  its('content') do
    should match(
      %r{vrrp_instance mysql-ipv4 {
	state MASTER
	virtual_router_id 5
	interface eth0
	priority 200
	authentication {
		auth_type PASS
		auth_pass foobar
		}
	virtual_ipaddress {
		140.211.9.47/24
		}
	}}
    )
  end
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__mysql-backend-ipv4__.conf' do
  its('content') do
    should match(
      %r{vrrp_instance mysql-backend-ipv4 {
	state MASTER
	virtual_router_id 6
	interface eth1
	priority 200
	authentication {
		auth_type PASS
		auth_pass foobar
		}
	virtual_ipaddress {
		10.1.0.86/23
		}
	}}
    )
  end
end

describe command('ip addr show eth0') do
  its('stdout') { should match %r{inet 140\.211\.9\.47\/24} }
end

describe command('ip addr show eth1') do
  its('stdout') { should match %r{inet 10\.1\.0\.86\/23} }
end
