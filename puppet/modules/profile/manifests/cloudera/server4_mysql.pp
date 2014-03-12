class profile::cloudera::server4_mysql {
  class { 'cloudera::cm::repo': } ->
  class { 'cloudera::java': } ->
  class { 'cloudera::cm::server':
    db_type => 'mysql',
  }

  include '::mysql::server'
  #class { 'cloudera':
  #  cm_server_host => $::fqdn,
  #} ->
  #class { 'cloudera::cm::server':
  #  db_type => 'mysql',
  #}
}
