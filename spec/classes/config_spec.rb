require 'spec_helper'

describe 'rsyslog::config' do
  describe 'defaults' do
    it { is_expected.to contain_class('rsyslog::params') }
    it { is_expected.to contain_file(ConfigFile)\
         .without_content(/imtcp|imudp|immark|UDPServerRun|InputTCPServerRun|MarkMessagePeriod|ActionWriteAllMarkMessages/)
       }
    it { is_expected.to contain_file("#{ConfigDir}/rules.conf") }
    it { is_expected.to_not contain_file("#{ConfigDir}/remote.conf") }
  end

  describe 'syslog server combined logs' do
    let (:params) {{ 'separate_hosts' => false }}
    it { 
         is_expected.to contain_file("#{ConfigDir}/rules.conf")\
         .with_content(/authpriv\.\*/) }
    it { 
         is_expected.to contain_file("#{ConfigDir}/rules.conf")\
         .without_content(/DYNmessages|DYNsecure|DYNmaillog|DYNcron|DYNspoller|DYNboot/) }
  end
  describe 'syslog server with separate logs per host' do
    let (:params) {{ 
      'separate_hosts'    => true,
      'separate_logs_dir' => '/var/log/fake/%HOSTNAME%'
    }}
    it { 
         is_expected.to contain_file("#{ConfigDir}/rules.conf")\
         .with_content(/\/var\/log\/fake\/%HOSTNAME%\/messages/)\
         .with_content(/DYNmessages/) 
    }
  end
  describe 'syslog server tcp only' do
    let (:params) {{ 'enable_tcp_server' => true }}
    it { 
         is_expected.to contain_file(ConfigFile)\
         .with_content(/\$ModLoad imtcp/)\
         .without_content(/\$ModLoad imudp/)
    }
  end
  describe 'syslog server udp only' do
    let (:params) {{ 'enable_udp_server' => true }}
    it { 
         is_expected.to contain_file(ConfigFile)\
         .without_content(/\$ModLoad imtcp/)\
         .with_content(/\$ModLoad imudp/)
    }
  end
  describe 'syslog server with tcp and udp' do
    let (:params) {{ 'enable_udp_server' => true, 'enable_tcp_server' => true }}
    it { 
         is_expected.to contain_file(ConfigFile)\
         .with_content(/\$ModLoad imtcp/)\
         .with_content(/\$ModLoad imudp/)
    }
  end
  describe 'syslog server with custom ports' do
    let (:params) {{ 
      'enable_udp_server' => true,
      'enable_tcp_server' => true,
      'tcp_server_port' => 5114,
      'udp_server_port' => 6114
    }}
    it { 
         is_expected.to contain_file(ConfigFile)\
         .with_content(/\$ModLoad imtcp/)\
         .with_content(/\$ModLoad imudp/)\
         .with_content(/\$InputTCPServerRun 5114/)\
         .with_content(/\$UDPServerRun 6114/)
    }
  end
  describe 'enable immark' do
    let (:params) {{ 'enable_immark' => true }}
    it { is_expected.to contain_file(ConfigFile)\
         .with_content(/\$ModLoad immark/) }
  end
  describe 'enable immark with custom inteval' do
    let (:params) {{ 'enable_immark' => true, 'immark_interval' => 300 }}
    it { 
         is_expected.to contain_file(ConfigFile)\
         .with_content(/\$ModLoad immark/)\
         .with_content(/\$MarkMessagePeriod 300/)
    }
  end
  describe 'enable immark with always mark' do
    let (:params) {{ 'enable_immark' => true, 'immark_always' => 'on' }}
    it { 
         is_expected.to contain_file(ConfigFile)\
         .with_content(/\$ModLoad immark/)\
         .with_content(/\$ActionWriteAllMarkMessages on/)
    }
  end
  describe 'enable remote log forwarding' do
    forwarding_rules = { 
      'host01' => { 
        'protocol' => 'tcp',
        'rule' => '*.*'
      },
      'host02' => { 
        'protocol' => 'udp', 
        'rule' => 'kern.*' 
      } 
    }
    let (:params) {{ 'forwarding_rules' => forwarding_rules }}
    it { 
         is_expected.to contain_file("#{ConfigDir}/remote.conf")\
         .with_content(/\*\.\*     @@host01/)\
         .with_content(/kern\.\*     @host02/)
    }
  end
end
