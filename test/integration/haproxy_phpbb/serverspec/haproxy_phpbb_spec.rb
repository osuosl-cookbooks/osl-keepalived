require 'spec_helper'

describe package 'keepalived' do
  it { should be_installed }
end

describe service 'keepalived' do
  it { should be_enabled }
  it { should be_running }
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-phpbb-ipv4__.conf' do
  its(:content) do
    should match(
      %r{vrrp_instance haproxy-phpbb-ipv4 {
	state MASTER
	virtual_router_id 3
	interface eth0
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

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-phpbb-ipv6__.conf' do
  it { should_not exist }
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_sync_group__haproxy-phpbb-group__.conf' do
  it { should_not exist }
end

describe interface 'eth0' do
  it { should have_ipv4_address '140.211.15.244/24' }
end
