class rsyslog::install (
  $package_name   = $rsyslog::params::package_name,
  $package_ensure = $rsyslog::params::package_ensure
) inherits rsyslog::params {

  package { $package_name:
    ensure => $package_ensure
  }

}
