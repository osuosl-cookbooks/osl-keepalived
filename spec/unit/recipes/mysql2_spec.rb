require_relative '../../spec_helper'

describe 'osl-keepalived::mysql2' do
  before do
    stub_data_bag_item('osl_keepalived', 'mysql_vip2').and_return(
      id: 'mysql',
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
      it do
        expect(chef_run.keepalived_vrrp_instance('mysql-backend-ipv4')).to notify('service[keepalived]').to(:reload)
      end
    end

    context "#{p[:platform]} #{p[:version]} for mysql3.osuosl.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'mysql3.osuosl.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql-ipv4').with(
          master: true,
          interface: 'eth0',
          virtual_router_id: 5,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.9.47/24)
        )
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql-backend-ipv4').with(
          master: true,
          interface: 'eth1',
          virtual_router_id: 6,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(10.1.0.86/23)
        )
      end
    end
    context "#{p[:platform]} #{p[:version]} for mysql4.osuosl.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'mysql4.osuosl.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql-ipv4').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 5,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.9.47/24)
        )
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('mysql-backend-ipv4').with(
          master: false,
          interface: 'eth1',
          virtual_router_id: 6,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(10.1.0.86/23)
        )
      end
    end
  end
end
