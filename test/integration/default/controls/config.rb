# frozen_string_literal: true

control 'backupninja configuration' do
  title 'should match desired lines'

  ['11-custom.sh', '12-custom-rsync.sh'].each do |file|
    describe file("/etc/backup.d/#{file}") do
      it { should be_file }
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
      its('mode') { should cmp '0640' }
    end
  end
end
