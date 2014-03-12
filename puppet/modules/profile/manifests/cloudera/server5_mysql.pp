class { 'profile::cloudera::server5_mysql':
  class { 'cloudera::cm5::repo': } ->
  class { 'cloudera::java5': } ->
  class { 'cloudera::cm5::server':
    db_type => 'mysql',
  }

  include '::mysql::server'
  #class { 'cloudera':
  #  cm_server_host => $::fqdn,
  #} ->
  #class { 'cloudera::cm5::server':
  #  db_type => 'mysql',
  #}
}
