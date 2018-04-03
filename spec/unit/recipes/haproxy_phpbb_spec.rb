require_relative '../../spec_helper'

describe 'osl-keepalived::haproxy_phpbb' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('vip-phpbb-lb1').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 2,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: nil },
          virtual_ipaddress: %w(140.211.15.244)
        )
      end
    end
  end
end
