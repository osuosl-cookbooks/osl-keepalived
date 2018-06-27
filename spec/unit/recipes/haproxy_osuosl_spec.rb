require_relative '../../spec_helper'

describe 'osl-keepalived::haproxy_osuosl' do
  before do
    stub_data_bag_item('osl_keepalived', 'haproxy_osuosl').and_return(
      id: 'haproxy_osuosl',
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
        expect(chef_run).to create_keepalived_vrrp_sync_group('haproxy-osuosl-group').with(
          group: %w(haproxy-osuosl-ipv4 haproxy-osuosl-ipv6)
        )
      end
      %w(ipv4 ipv6).each do |ip|
        it do
          expect(chef_run.keepalived_vrrp_instance("haproxy-osuosl-#{ip}")).to notify('service[keepalived]').to(:reload)
        end
      end
      it do
        expect(chef_run.keepalived_vrrp_sync_group('haproxy-osuosl-group')).to notify('service[keepalived]').to(:reload)
      end
    end

    context "#{p[:platform]} #{p[:version]} for lb1.osuosl.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'lb1.osuosl.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-osuosl-ipv4').with(
          master: true,
          interface: 'eth0',
          virtual_router_id: 1,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.9.53/24)
        )
      end

      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-osuosl-ipv6').with(
          master: true,
          interface: 'eth0',
          virtual_router_id: 2,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(2605:bc80:3010:104::8cd3:935/64)
        )
      end
    end
    context "#{p[:platform]} #{p[:version]} for lb2.osuosl.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'lb2.osuosl.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-osuosl-ipv4').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 1,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.9.53/24)
        )
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-osuosl-ipv6').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 2,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(2605:bc80:3010:104::8cd3:935/64)
        )
      end
    end
  end
end
