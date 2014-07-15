class rsyslog::service (
  $service_name   = $rsyslog::params::service_name,
  $service_ensure = $rsyslog::params::service_ensure,
  $service_enable = $rsyslog::params::service_enable
) inherits rsyslog::params {

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable
  }

}
