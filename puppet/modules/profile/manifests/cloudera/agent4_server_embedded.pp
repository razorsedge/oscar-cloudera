class profile::cloudera::agent4_server_embeded {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    cm_version       => '4',
    install_cmserver => true,
  }
}
