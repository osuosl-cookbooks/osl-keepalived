# rubocop:disable Layout/IndentationStyle
describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__mysql-ipv4__.conf' do
  its('content') do
    should match(
%r(vrrp_instance mysql-ipv4 {
  virtual_router_id 5
  state MASTER
  interface eth2
  priority 200
  authentication {
    auth_type PASS
    auth_pass foobar
  }
  virtual_ipaddress {
    140.211.9.47/24
  }


}))
  end
end
# rubocop:enable Layout/IndentationStyle

# rubocop:disable Layout/IndentationStyle
describe file '/etc/keepalived/conf.d/keepalived_vrrp_instance__mysql-backend-ipv4__.conf' do
  its('content') do
    should match(
%r(vrrp_instance mysql-backend-ipv4 {
  virtual_router_id 6
  state MASTER
  interface eth1
  priority 200
  authentication {
    auth_type PASS
    auth_pass foobar
  }
  virtual_ipaddress {
    10.1.0.86/23
  }


}))
  end
end
# rubocop:enable Layout/IndentationStyle

[
  ['eth2', '140.211.9.47/24'],
  ['eth1', '10.1.0.86/23'],
].each do |dev, ip|
  60.times do
    if inspec.command("ip addr show #{dev}").stdout.chomp =~ /inet #{ip}/
      break
    else
      puts("Waiting for keepalived to configure #{dev}...")
      sleep(1)
    end
  end

  describe interface dev do
    its('ipv4_cidrs') { should include ip }
  end
end
