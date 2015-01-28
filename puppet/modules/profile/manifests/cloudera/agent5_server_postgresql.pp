class profile::cloudera::agent5_server_postgresql {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
    db_type          => 'postgresql',
    db_user          => 'postgres',
    db_pass          => 'TPSrep0rt!',
    db_port          => '5432',
  }
  class { '::postgresql::server':
    postgres_password => 'TPSrep0rt!',
#    locale            => 'en_US.UTF-8',
  }
}
