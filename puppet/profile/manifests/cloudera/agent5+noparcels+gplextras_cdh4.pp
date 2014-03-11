class { 'profile::cloudera::agent5+noparcels+gplextras_cdh4':
  class { 'cloudera':
    cm_server_host => $::fqdn,
    use_parcels    => false,
    use_gplextras  => true,
    cdh_version    => '4',
  }
}
