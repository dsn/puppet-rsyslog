require 'spec_helper'

describe 'rsyslog::service' do
  it { is_expected.to contain_class('rsyslog::params') }
  it { is_expected.to contain_service('rsyslog').with('ensure' => 'running', 'enable' => true) }
  describe 'override service name' do
    let (:params) {{ 'service_name' => 'fake' }}
    it { is_expected.to contain_service('fake').with('ensure' => 'running', 'enable' => true) }
  end
end
