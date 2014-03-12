class { 'profile::cloudera::agent5-java':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    install_java   => false,
  }
}
