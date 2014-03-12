class profile::cloudera::server5_postgresql {
  class { 'cloudera::cm5::repo': } ->
  class { 'cloudera::java5': } ->
  class { 'cloudera::cm5::server':
    db_type => 'postgresql',
    db_user => 'postgres',
    db_pass => '',
    db_port => '5432',
  }

  include '::postgresql::server'
  #class { 'cloudera':
  #  cm_server_host => $::fqdn,
  #} ->
  #class { 'cloudera::cm5::server':
  #  db_type => 'postgresql',
  #}
}
