class { 'profile::cloudera::agent5_noparcels_cdh4':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    use_parcels    => false,
    cdh_version    => '4',
  }
}
