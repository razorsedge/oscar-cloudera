class { 'profile::cloudera::agent5_noparcels_gplextras_cdh5':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    use_parcels    => false,
    use_gplextras  => true,
  }
}
