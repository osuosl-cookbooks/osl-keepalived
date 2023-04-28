require_relative '../../spec_helper'

describe 'osl-keepalived::mysql1' do
  before do
    stub_data_bag_item('osl_keepalived', 'mysql_vip1').and_return(
      id: 'mysql_vip1',
      auth_pass: 'foobar'
    )
  end
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run.keepalived_vrrp_instance('mysql-ipv4')).to notify('service[keepalived]').to(:reload)
      end
    end

    context "#{p[:platform]} #{p[:version]} for mysql1.osuosl.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'mysql1.osuosl.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql-ipv4').with(
          master: true,
          interface: 'eth0',
          virtual_router_id: 7,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.15.221/24)
        )
      end
    end
    context "#{p[:platform]} #{p[:version]} for mysql2.osuosl.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'mysql2.osuosl.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql-ipv4').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 7,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.15.221/24)
        )
      end
    end
  end
end
