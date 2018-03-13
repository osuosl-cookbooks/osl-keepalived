require_relative '../../spec_helper'

describe 'osl-keepalived::haproxy_phpbb' do
  before do
    stub_data_bag_item('osl_keepalived', 'haproxy_phpbb').and_return(
      id: 'haproxy_phpbb',
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
        expect(chef_run).to_not create_keepalived_vrrp_sync_group('haproxy-phpbb-group').with(
          group: %w(haproxy-phpbb-ipv4 haproxy-phpbb-ipv6)
        )
      end
      it do
        expect(chef_run.keepalived_vrrp_instance('haproxy-phpbb-ipv4')).to notify('service[keepalived]').to(:reload)
      end
    end

    context "#{p[:platform]} #{p[:version]} for lb1.phpbb.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'lb1.phpbb.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-phpbb-ipv4').with(
          master: true,
          interface: 'eth0',
          virtual_router_id: 3,
          priority: 200,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.15.244/24)
        )
      end
      it do
        expect(chef_run).to_not create_keepalived_vrrp_instance('haproxy-phpbb-ipv6')
      end
    end
    context "#{p[:platform]} #{p[:version]} for lb2.phpbb.org" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic_attrs['fqdn'] = 'lb2.phpbb.org'
        end.converge(described_recipe)
      end
      it do
        expect(chef_run).to create_keepalived_vrrp_instance('haproxy-phpbb-ipv4').with(
          master: false,
          interface: 'eth0',
          virtual_router_id: 3,
          priority: 100,
          authentication: { auth_type: 'PASS', auth_pass: 'foobar' },
          virtual_ipaddress: %w(140.211.15.244/24)
        )
      end
      it do
        expect(chef_run).to_not create_keepalived_vrrp_instance('haproxy-phpbb-ipv6')
      end
    end
  end
end
