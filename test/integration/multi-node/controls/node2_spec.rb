control 'node2' do
  describe command('ip a') do
    its('stdout') { should_not match '192.168.60.10' }
  end
end
