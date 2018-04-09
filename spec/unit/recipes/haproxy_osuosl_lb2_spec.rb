require_relative '../../spec_helper'

describe 'osl-keepalived::haproxy_osuosl_lb2' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-osuosl-lb2').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 1,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: nil },
          virtual_ipaddress: %w(140.211.9.53)
        )
      end
    end
  end
end
