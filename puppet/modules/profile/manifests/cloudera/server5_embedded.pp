class profile::cloudera::server5_embeded {
  class { 'cloudera::cm5::repo': } ->
  class { 'cloudera::java5': } ->
  class { 'cloudera::cm5::server': }

  #class { 'cloudera':
  #  cm_server_host => $::fqdn,
  #} ->
  #class { 'cloudera::cm5::server': }
}
