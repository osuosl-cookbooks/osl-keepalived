require 'spec_helper'

describe package 'keepalived' do
  it { should be_installed }
end

describe service 'keepalived' do
  it { should be_enabled }
  it { should be_running }
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__mysql-ipv4__.conf' do
  its(:content) do
    should match(
      %r{vrrp_instance mysql-ipv4 {
	state BACKUP
	virtual_router_id 5
	interface eth0
	priority 100
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
  its(:content) do
    should match(
      %r{vrrp_instance mysql-backend-ipv4 {
	state BACKUP
	virtual_router_id 6
	interface eth1
	priority 100
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

describe interface 'eth0' do
  it { should have_ipv4_address '140.211.9.47/24' }
end

describe interface 'eth1' do
  it { should have_ipv4_address '10.1.0.86/23' }
end
