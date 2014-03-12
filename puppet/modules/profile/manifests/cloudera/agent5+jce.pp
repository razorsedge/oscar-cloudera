class { 'profile::cloudera::agent5_jce':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    install_jce    => true,
  }
}
