class rsyslog::config (
  $enable_tcp_server = $rsyslog::params::enable_tcp_server,
  $enable_udp_server = $rsyslog::params::enable_udp_server,
  $udp_server_port   = $rsyslog::params::udp_serve_port,
  $tcp_server_port   = $rsyslog::params::tcp_server_port,
  $separate_hosts    = $rsyslog::params::separate_hosts,
  $enable_immark     = $rsyslog::params::enable_immark,
  $immark_interval   = $rsyslog::params::immark_interval,
  $forwarding_rules  = {},
  $config_file       = $rsyslog::params::config_file,
  $config_dir        = $rsyslog::params::config_dir,
  $provider          = $rsyslog::params::provider
) inherits rsyslog::params {

  file { '/tmp/rsyslog.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('rsyslog/rsyslog.conf.erb'),
    require => Package[$rsyslog::package_name]
  }

  file { '/tmp/rsyslog.d/00-local.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('rsyslog/rules/default.conf.erb'),
    require => Package[$rsyslog::package_name]
  }

  if $forward_rules {
    file { '/tmp/rsyslog.d/10-remote.conf':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('rsyslog/rules/remote.conf.erb'),
      require => Package[$rsyslog::package_name]
    }
  }

}
