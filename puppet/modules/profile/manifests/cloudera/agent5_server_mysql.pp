class profile::cloudera::agent5_server_mysql {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
    db_type          => 'mysql',
  }
  include '::mysql::server'
  if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease == '5') and ($::operatingsystem != 'Fedora') {
    include '::epel'
    Class['::epel'] -> Class['::mysql::bindings::java']
  }
}
