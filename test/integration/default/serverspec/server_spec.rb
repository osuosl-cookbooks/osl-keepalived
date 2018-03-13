require 'spec_helper'

set :backend, :exec

describe 'keepalived' do
  it_behaves_like 'keepalived'
end
