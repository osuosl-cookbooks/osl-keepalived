control 'node1' do
  describe command('ip a') do
    its('stdout') { should match '192.168.60.10' }
  end
end
