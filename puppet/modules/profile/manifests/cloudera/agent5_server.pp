class profile::cloudera::agent5_server {
  class { 'cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
  }
}
