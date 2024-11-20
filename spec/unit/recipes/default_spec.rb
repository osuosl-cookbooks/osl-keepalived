require_relative '../../spec_helper'

describe 'osl-keepalived::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { is_expected.to include_recipe 'osl-selinux' }
      it { is_expected.to accept_osl_firewall_vrrp 'osl-keepalived' }
      it { is_expected.to install_keepalived_install 'keepalived' }
      it { is_expected.to create_selinux_module('keepalived_custom').with(source: 'keepalived_custom.te') }
    end
  end
end
