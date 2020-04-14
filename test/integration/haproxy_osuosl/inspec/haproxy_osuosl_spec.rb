describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-osuosl-ipv4__.conf' do
  its('content') do
    should match(
      %r{vrrp_instance haproxy-osuosl-ipv4 {
	state MASTER
	virtual_router_id 1
	interface eth1
	priority 200
	authentication {
		auth_type PASS
		auth_pass foobar
		}
	virtual_ipaddress {
		140.211.9.53/24
		}
	}}
    )
  end
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-osuosl-ipv6__.conf' do
  its('content') do
    should match(
      %r{vrrp_instance haproxy-osuosl-ipv6 {
	state MASTER
	virtual_router_id 2
	interface eth1
	priority 200
	authentication {
		auth_type PASS
		auth_pass foobar
		}
	virtual_ipaddress {
		2605:bc80:3010:104::8cd3:935/64
		}
	}}
    )
  end
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_sync_group__haproxy-osuosl-group__.conf' do
  its('content') do
    should match(
      /vrrp_sync_group haproxy-osuosl-group {
	group {
		haproxy-osuosl-ipv4
		haproxy-osuosl-ipv6
		}
	}/
    )
  end
end

describe command('ip address show eth1') do
  its('stdout') { should match %r{inet 140\.211\.9\.53\/24[\s\S]*inet6 2605:bc80:3010:104::8cd3:935\/64} }
end
