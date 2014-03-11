class { 'profile::cloudera::server4+postgresql':
  class { 'cloudera::cm::repo': } ->
  class { 'cloudera::java': } ->
  class { 'cloudera::cm::server':
    db_type => 'postgresql',
    db_user => 'postgres',
    db_pass => '',
    db_port => '5432',
  }

  include '::postgresql::server'
  #class { 'cloudera':
  #  cm_server_host => $::fqdn,
  #} ->
  #class { 'cloudera::cm::server':
  #  db_type => 'postgresql',
  #}
}
