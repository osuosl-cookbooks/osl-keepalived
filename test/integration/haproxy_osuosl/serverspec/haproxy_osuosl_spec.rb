require 'spec_helper'

describe package 'keepalived' do
  it { should be_installed }
end

describe service 'keepalived' do
  it { should be_enabled }
  it { should be_running }
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-osuosl-ipv4__.conf' do
  its(:content) do
    should match(
      %r{vrrp_instance haproxy-osuosl-ipv4 {
	state MASTER
	virtual_router_id 1
	interface eth0
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
  its(:content) do
    should match(
      %r{vrrp_instance haproxy-osuosl-ipv6 {
	state MASTER
	virtual_router_id 2
	interface eth0
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
  its(:content) do
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

describe interface 'eth0' do
  it { should have_ipv4_address '140.211.9.53/24' }
  it { should have_ipv6_address '2605:bc80:3010:104::8cd3:935/64' }
end
