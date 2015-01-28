class profile::cloudera::agent5_server_mysql {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
    db_type          => 'mysql',
  }
  include '::mysql::server'
}
