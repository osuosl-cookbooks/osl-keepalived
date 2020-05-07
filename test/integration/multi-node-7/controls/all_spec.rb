control 'all' do
  %w(10 11 12).each do |suff|
    describe host("192.168.60.#{suff}") do
      it { should be_reachable }
    end
  end

  describe host('192.168.60.13') do
    it { should_not be_reachable }
  end

  describe http('192.168.60.10') do
    its('body') { should eq 'node1.novalocal' }
  end
end
