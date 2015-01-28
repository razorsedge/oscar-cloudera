class profile::cloudera::agent5_server_embeded {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
  }
}
