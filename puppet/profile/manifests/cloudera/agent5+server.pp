class { 'profile::cloudera::agent5+server':
  class { 'cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
  }
}
