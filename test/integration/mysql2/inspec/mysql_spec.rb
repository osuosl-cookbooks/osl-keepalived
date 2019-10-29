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

[
  ['eth0', %r{140\.211\.9\.47/24}],
  ['eth1', %r{10\.1\.0\.86/23}],
].each do |dev, ip|
  60.times do
    if inspec.command("ip addr show #{dev}").stdout.chomp =~ /inet #{ip}/
      describe command("ip addr show #{dev}") do
        its('stdout') { should match /inet #{ip}/ }
      end
      break
    else
      puts('Waiting...')
      sleep(1)
    end
  end
end
