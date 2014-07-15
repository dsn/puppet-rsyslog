require 'spec_helper'

describe 'rsyslog::install' do
  it { is_expected.to contain_package('rsyslog') }
end
