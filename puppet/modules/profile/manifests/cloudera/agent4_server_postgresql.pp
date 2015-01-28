class profile::cloudera::agent4_server_postgresql {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    cm_version       => '4',
    install_cmserver => true,
    db_type          => 'postgresql',
    db_user          => 'postgres',
    db_pass          => 'TPSrep0rt!',
    db_port          => '5432',
  }
  class { '::postgresql::server':
    postgres_password => 'TPSrep0rt!',
#    encoding          => 'UTF-8',
#    locale            => 'en_US.UTF-8',
#    needs_initdb      => true,
  }
}
