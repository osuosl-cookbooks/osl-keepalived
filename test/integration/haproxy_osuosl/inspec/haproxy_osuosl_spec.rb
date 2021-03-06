describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-osuosl-ipv4__.conf' do
  its('content') do
    should match(
%r(vrrp_instance haproxy-osuosl-ipv4 {
  virtual_router_id 1
  state MASTER
  interface eth1
  priority 200
  authentication {
    auth_type PASS
    auth_pass foobar
  }
  virtual_ipaddress {
    140.211.9.53/24
  }


}))
  end
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__haproxy-osuosl-ipv6__.conf' do
  its('content') do
    should match(
%r(vrrp_instance haproxy-osuosl-ipv6 {
  virtual_router_id 2
  state MASTER
  interface eth1
  priority 200
  authentication {
    auth_type PASS
    auth_pass foobar
  }
  virtual_ipaddress {
    2605:bc80:3010:104::8cd3:935/64
  }


}))
  end
end

describe file '/etc/keepalived/conf.d/keepalived_vrrp_sync_group__haproxy-osuosl-group__.conf' do
  its('content') do
    should match(
%r(vrrp_sync_group haproxy-osuosl-group {
  group {
    haproxy-osuosl-ipv4
    haproxy-osuosl-ipv6
  }
}))
  end
end

describe service 'keepalived' do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

60.times do
  if inspec.command('ip addr show eth1').stdout.chomp =~ %r{inet 140\.211\.9\.53\/24}
    break
  else
    puts('Waiting for keepalived to configure eth1...')
    sleep(1)
  end
end
describe interface 'eth1' do
  its('ipv4_cidrs') { should include '140.211.9.53/24' }
  its('ipv6_cidrs') { should include '2605:bc80:3010:104::8cd3:935/64' }
end
