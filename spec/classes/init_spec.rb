require 'spec_helper'

describe 'rsyslog' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('rsyslog::params') }
  it { is_expected.to contain_class('rsyslog::install') }
  it { is_expected.to contain_class('rsyslog::config') }
  it { is_expected.to contain_class('rsyslog::service') }
  describe 'override package name' do
    let (:params) {{ 'package_name' => 'fake' }}
    it { is_expected.to contain_class('rsyslog').with('package_name' => 'fake') }
  end
  describe 'override service name' do
    let (:params) {{ 'service_name' => 'fake' }}
    it { is_expected.to contain_class('rsyslog').with('service_name' => 'fake') }
  end
end # end test
