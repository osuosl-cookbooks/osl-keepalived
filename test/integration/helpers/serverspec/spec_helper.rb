require 'serverspec'

set :backend, :exec

shared_examples_for 'keepalived' do
  describe service 'keepalived' do
    it { should be_enabled }
    it { should be_running }
  end
end
