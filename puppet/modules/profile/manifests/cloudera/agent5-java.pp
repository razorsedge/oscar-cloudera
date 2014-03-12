class { 'profile::cloudera::agent5_java':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    install_java   => false,
  }
}
