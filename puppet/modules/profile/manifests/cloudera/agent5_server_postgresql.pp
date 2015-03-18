class profile::cloudera::agent5_server_postgresql {
  class { '::cloudera':
    cm_server_host   => $::fqdn,
    install_cmserver => true,
    db_type          => 'postgresql',
    db_user          => 'postgres',
    db_pass          => 'TPSrep0rt!',
    db_port          => '5432',
  }
  if $::osfamily == 'Debian' {
    $require = Class['locales']
  } else {
    $require = undef
  }
  class { '::postgresql::server':
    postgres_password => 'TPSrep0rt!',
    encoding          => 'UTF-8',
#    locale            => 'en_US.UTF-8',
#    require            => $require,
  }
  if $::osfamily == 'Debian' {
    # From puppetlbas/postgresql 4.1.0 Class['postgresql::globals']
    $version = $::osfamily ? {
      'Debian' => $::operatingsystem ? {
        'Debian' => $::operatingsystemrelease ? {
          /^6\./ => '8.4',
          /^(wheezy|7\.)/ => '9.1',
          /^(jessie|8\.)/ => '9.3',
        default => undef,
          },
        'Ubuntu' => $::operatingsystemrelease ? {
          /^(14.04)$/ => '9.3',
          /^(11.10|12.04|12.10|13.04|13.10)$/ => '9.1',
          /^(10.04|10.10|11.04)$/ => '8.4',
          default => undef,
        },
        default => undef,
      },
      default => undef,
    }

    # https://stackoverflow.com/questions/15949783/postgresql-is-being-installed-with-sql-ascii-using-puppet
    # workaround for http://projects.puppetlabs.com/issues/4695
    # when PostgreSQL is installed with SQL_ASCII encoding instead of UTF8
    exec { 'utf8 postgres':
      command => "pg_dropcluster --stop ${version} main ; pg_createcluster --start --locale en_US.UTF-8 ${version} main",
      unless  => 'sudo -u postgres psql -t -c "\l" | grep template1 | grep -q UTF',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      require => Class['postgresql::server'],
#      before  => Exec['scm_prepare_database'],
    }
  }
}
