# rubocop:disable Layout/IndentationStyle
describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-phpbb-ipv4__.conf' do
  its('content') do
    should match(
      %r{vrrp_instance haproxy-phpbb-ipv4 {
	state MASTER
	virtual_router_id 3
	interface eth1
	priority 200
	authentication {
		auth_type PASS
		auth_pass foobar
		}
	virtual_ipaddress {
		140.211.15.244/24
		}
	}}
    )
  end
end
# rubocop:enable Layout/IndentationStyle

# rubocop:disable Layout/IndentationStyle
describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-phpbb-ipv6__.conf' do
  its('content') do
    should match(
      %r{vrrp_instance haproxy-phpbb-ipv6 {
	state MASTER
	virtual_router_id 4
	interface eth1
	priority 200
	authentication {
		auth_type PASS
		auth_pass foobar
		}
	virtual_ipaddress {
		2605:bc80:3010:103::8cd3:ff4/64
		}
	}}
    )
  end
end
# rubocop:enable Layout/IndentationStyle

# rubocop:disable Layout/IndentationStyle
describe file '/etc/keepalived/conf.d/keepalived_vrrp_sync_group__haproxy-phpbb-group__.conf' do
  its('content') do
    should match(
      /vrrp_sync_group haproxy-phpbb-group {
	group {
		haproxy-phpbb-ipv4
		haproxy-phpbb-ipv6
		}
	}/
    )
  end
end
# rubocop:enable Layout/IndentationStyle

60.times do
  if inspec.command('ip addr show eth1').stdout.chomp =~ %r{inet 140\.211\.15\.244\/24}
    break
  else
    puts('Waiting for keepalived to configure eth1...')
    sleep(1)
  end
end
describe command('ip addr show eth1') do
  its('stdout') { should match %r{inet 140\.211\.15\.244\/24[\s\S]*inet6 2605:bc80:3010:103::8cd3:ff4\/64} }
end
