class { 'profile::cloudera::agent5+jce':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    install_jce    => true,
  }
}
