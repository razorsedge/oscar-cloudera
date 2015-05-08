class profile::cloudera::agent5 {
  class { 'cloudera':
    cm_server_host => 'master',
    autoupgrade    => true,
  }
  #include '::ntp'
  class { '::ntp':
    servers       => [ 'time' ],
    iburst_enable => true,
  }
}
