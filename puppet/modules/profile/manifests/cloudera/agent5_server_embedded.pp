class profile::cloudera::agent5_server_embedded {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
  }
}
