class { 'profile::cloudera::agent5+noparcels_cdh4':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    use_parcels    => false,
    cdh_version    => '4',
  }
}
