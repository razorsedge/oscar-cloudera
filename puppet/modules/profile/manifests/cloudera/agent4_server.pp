class profile::cloudera::agent4_server {
  class { '::cloudera':
    cm_server_host   => 'master',
    cm_version       => '4',
    install_cmserver => true,
  }
  #include '::ntp'
  class { '::ntp':
    servers       => [ 'time' ],
    iburst_enable => true,
  }
}
