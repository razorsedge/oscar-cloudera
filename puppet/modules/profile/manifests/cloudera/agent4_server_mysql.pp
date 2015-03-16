class profile::cloudera::agent4_server_mysql {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    cm_version       => '4',
    install_cmserver => true,
    db_type          => 'mysql',
  }
  include '::mysql::server'
  if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease == '5') and ($::operatingsystem != 'Fedora') {
    include '::epel'
    Class['::epel'] -> Class['::mysql::bindings::java']
  }
}
