class profile::cloudera::server4_embedded {
  class { 'cloudera::cm::repo': } ->
  class { 'cloudera::java': } ->
  class { 'cloudera::cm::server': }

  #class { 'cloudera':
  #  cm_server_host => $::fqdn,
  #} ->
  #class { 'cloudera::cm::server': }
}
