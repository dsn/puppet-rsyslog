# == Class: rsyslog::params
#
# This class defines default parameters used by the main module class rsyslog
#
# Operating Systems differences in names and paths are addressed here
#
# === Variables
#
# Refer to the main rsyslog class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class rsyslog::params {

  # Centralized Syslog Server Features
  $enable_tcp_transport  = false
  $enable_udp_transport  = false

  $tcp_listen_port       = 514
  $udp_listen_port       = 514

  $tcp_listen_address    = '0.0.0.0'
  $udp_listen_address    = '0.0.0.0'

  $seperate_logs_by_host = false
  $host_logs_dir         = '/var/log/hosts/%HOSTNAME%'
  $enable_ondisk_queue   = false

  # Host Based Features

  $enable_mark           = false
  $always_mark           = false
  $mark_interval         = 600

  $forward_rules         = { }

  $package_ensure        = present
  $service_ensure        = running
  $service_enable        = true

  # Module Internals
  # DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING
  $config_file  = '/etc/rsyslog.conf'
  $config_dir   = '/etc/rsyslog.d'

  $package_name = 'rsyslog'
  $service_name = 'rsyslog'

  # Marks Class as Private
  if $caller_module_name != undef and $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
