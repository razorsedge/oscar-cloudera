class profile::cloudera::agent4 {
  class { '::cloudera':
    cm_server_host => $::fqdn,
    cm_version     => '4',
  }
}
