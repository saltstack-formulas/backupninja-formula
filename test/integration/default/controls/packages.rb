# frozen_string_literal: true

control 'backupninja package' do
  title 'should be installed'

  describe package('backupninja') do
    it { should be_installed }
  end
end
