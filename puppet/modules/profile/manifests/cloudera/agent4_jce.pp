class profile::cloudera::agent4_jce {
  class { '::cloudera':
    cm_server_host => $::fqdn,
    cm_version     => '4',
    install_jce    => true,
  }
}
