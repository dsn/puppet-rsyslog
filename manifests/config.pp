class rsyslog::config (
  $enable_tcp_server = $rsyslog::params::enable_tcp_server,
  $enable_udp_server = $rsyslog::params::enable_udp_server,
  $udp_server_port   = $rsyslog::params::udp_serve_port,
  $tcp_server_port   = $rsyslog::params::tcp_server_port,
  $separate_hosts    = $rsyslog::params::separate_hosts,
  $separate_logs_dir = $rsyslog::params::separate_logs_dir,
  $enable_immark     = $rsyslog::params::enable_immark,
  $immark_interval   = $rsyslog::params::immark_interval,
  $immark_always     = $rsyslog::params::immark_always,
  $forwarding_rules  = '',
  $config_file       = $rsyslog::params::config_file,
  $include_dir       = $rsyslog::params::include_dir
) inherits rsyslog::params {

  case $separate_hosts {
    true: {
      $rules_template = template('rsyslog/rules/separate_hosts.conf.erb')
    }
    false: {
      $rules_template = template('rsyslog/rules/default.conf.erb')
    }
    default: {
      fail("Invalid value for 'separate_hosts' ${separate_hosts}")
    }
  }

  validate_absolute_path($config_file)
  validate_absolute_path($include_dir)

  file { $config_file:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('rsyslog/rsyslog.conf.erb'),
    require => Class['rsyslog::install']
  }

  file { "${include_dir}/rules.conf":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => $rules_template,
    require => Class['rsyslog::install']
  }

  if type($forwarding_rules) == 'hash' {
    file { "${include_dir}/remote.conf":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('rsyslog/rules/remote.conf.erb'),
      require => Class['rsyslog::install']
    }
  }

}
