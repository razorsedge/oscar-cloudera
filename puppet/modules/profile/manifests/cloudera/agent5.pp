class profile::cloudera::agent5 {
  class { 'cloudera':
    cm_server_host => $::fqdn,
  }
}
