class profile::cloudera::agent5_server {
  class { '::cloudera':
    cm_server_host   => 'master',
    install_cmserver => true,
    autoupgrade      => true,
  }
  #include '::ntp'
  class { '::ntp':
    servers       => [ 'time' ],
    iburst_enable => true,
  }
}
