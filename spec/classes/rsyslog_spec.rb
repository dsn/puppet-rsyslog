require 'spec_helper'

describe 'rsyslog' do
  it { is_expected.to compile }
  it { is_expected.to contain_class('rsyslog::install') }
  it { is_expected.to contain_class('rsyslog::config') }
  it { is_expected.to contain_class('rsyslog::service') }
end # end test
