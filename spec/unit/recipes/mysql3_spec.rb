require_relative '../../spec_helper'

describe 'osl-keepalived::mysql3' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql3').with(
          master: true,
          interface: 'eth0',
          virtual_router_id: 3,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: nil },
          virtual_ipaddress: %w(140.211.9.47)
        )
      end
    end
  end
end
