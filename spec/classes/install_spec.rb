require 'spec_helper'

describe 'rsyslog::install' do
  it { is_expected.to contain_class('rsyslog::params') }
  it { is_expected.to contain_package('rsyslog').with_ensure('latest') }
  describe 'override package name' do
    let (:params) {{ 'package_name' => 'fake' }}
    it { is_expected.to contain_package('fake').with('ensure' => 'latest') }
  end
end
