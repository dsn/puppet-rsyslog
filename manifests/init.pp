# == Class: rsyslog
#
# This Module manages rsyslog configuration.
# See README.md for details
#
class rsyslog (
  $enable_tcp_server = $rsyslog::params::listen_tcp,
  $enable_udp_server = $rsyslog::params::listen_udp,
  $udp_server_port   = $rsyslog::params::listen_tcp_port,
  $tcp_server_port   = $rsyslog::params::listen_upd_port,
  $seperate_hosts    = $rsyslog::params::seperate_hosts,
  $enable_immark     = $rsyslog::params::enable_mark_messages,
  $immark_interval   = $rsyslog::params::mark_interval,
  $forwarding_rules  = $rsyslog::params::forwarding_rules,
  $package_name      = $rsyslog::params::package_name,
  $package_ensure    = $rsyslog::params::package_ensure,
  $service_name      = $rsyslog::params::service_name,
  $service_ensure    = $rsyslog::params::service_ensure,
  $service_enable    = $rsyslog::params::service_enable
) inherits rsyslog::params {

  class { 'rsyslog::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }

  class { 'rsyslog::config':
    enable_tcp_server => $enable_tcp_server,
    enable_udp_server => $enable_udp_server,
    udp_server_port   => $udp_server_port,
    tcp_server_port   => $tcp_server_port,
    seperate_hosts    => $seperate_host,
    enable_immark     => $enable_immark,
    immark_interval   => $immark_interval,
    forwarding_rules  => $forwarding_rules
  }

  class { 'rsyslog::service':
    service_name   => $service_name,
    service_ensure => $service_ensure,
    service_enable => $service_enable
  }

  Class['rsyslog::install'] ->
  Class['rsyslog::config'] ~>
  Class['rsyslog::service']

}
