#!/bin/sh
pe_major_version=`/opt/puppet/bin/facter -p pe_major_version`
pe_minor_version=`/opt/puppet/bin/facter -p pe_minor_version`
pe_patch_version=`/opt/puppet/bin/facter -p pe_patch_version`

echo "*** PE version is: ${pe_major_version}.${pe_minor_version}.${pe_patch_version}"
cp -p /vagrant/pe_license.key /etc/puppetlabs/license.key

if [ "$pe_major_version" -eq 2 -o \( "$pe_major_version" -eq 3 -a "$pe_minor_version" -lt 7 \) ]; then
  # PE < 3.7.x
/opt/puppet/bin/puppet config set modulepath /etc/puppetlabs/puppet/modules:/modules:/opt/puppet/share/puppet/modules --section main

/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[profile::cloudera::agent4_server_embedded,skip] \
nodeclass:add[profile::cloudera::agent4_server_mysql,skip] \
nodeclass:add[profile::cloudera::agent4_server_postgresql,skip] \
nodeclass:add[profile::cloudera::agent5_server_embedded,skip] \
nodeclass:add[profile::cloudera::agent5_server_mysql,skip] \
nodeclass:add[profile::cloudera::agent5_server_postgresql,skip] \
nodegroup:add[cm4_embedded,profile::cloudera::agent4_server_embedded,skip] \
nodegroup:add[cm4_mysql,profile::cloudera::agent4_server_mysql,skip] \
nodegroup:add[cm4_postgresql,profile::cloudera::agent4_server_postgresql,skip] \
nodegroup:add[cm5_embedded,profile::cloudera::agent5_server_embedded,skip] \
nodegroup:add[cm5_mysql,profile::cloudera::agent5_server_mysql,skip] \
nodegroup:add[cm5_postgresql,profile::cloudera::agent5_server_postgresql,skip]

/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[profile::cloudera::agent5_noparcels_gplextras_cdh5,skip] \
nodeclass:add[profile::cloudera::agent5_noparcels_gplextras_cdh4,skip] \
nodegroup:add[cm5_noparcels_gplextras_cdh5,profile::cloudera::agent5_noparcels_gplextras_cdh5,skip] \
nodegroup:add[cm5_noparcels_gplextras_cdh4,profile::cloudera::agent5_noparcels_gplextras_cdh4,skip]

/opt/puppet/bin/puppet module install attachmentgenie/locales
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[locales,skip] \
nodegroup:add[debian,locales,skip] \
nodeclass:add[apt,skip] \
nodegroup:addclass[debian,apt,skip] \
nodegroup:addclassparam[debian,apt,proxy_host,proxy] \
nodegroup:addclassparam[debian,apt,proxy_port,3128] \
node:add[debian6,debian,,skip] \
node:addgroup[debian6,debian] \
node:add[debian7,debian,,skip] \
node:addgroup[debian7,debian] \
node:add[ubuntu1004,debian,,skip] \
node:addgroup[ubuntu1004,debian] \
node:add[ubuntu1204,debian,,skip] \
node:addgroup[ubuntu1204,debian] \
node:add[ubuntu1404,debian,,skip] \
node:addgroup[ubuntu1404,debian]

/opt/puppet/bin/puppet module install spiette/selinux
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[selinux,skip] \
nodegroup:add[redhat,selinux,skip] \
nodegroup:addclassparam[redhat,selinux,mode,disabled] \
node:add[centos5,redhat,,skip] \
node:addgroup[centos5,redhat] \
node:add[centos6,redhat,,skip] \
node:addgroup[centos6,redhat]
else
  # PE >= 3.7.x
  /opt/puppet/bin/puppet config set basemodulepath /etc/puppetlabs/puppet/modules:/modules:/opt/puppet/share/puppet/modules --section main
  mkdir -p /var/lib/hiera
  echo -e "---\npuppet_enterprise::profile::master::java_args:\n  Xmx: 512m\n  Xms: 512m" >/var/lib/hiera/global.yaml
  cat <<EOF >>/etc/puppetlabs/puppet/environments/production/manifests/site.pp
# https://ask.puppetlabs.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  \$allow_virtual_packages = hiera('allow_virtual_packages',false)
  Package {
    allow_virtual => \$allow_virtual_packages,
  }
}
EOF

  /opt/puppet/bin/puppet module install attachmentgenie/locales
  /opt/puppet/bin/puppet module install spiette/selinux
  service pe-puppetserver restart
  sleep 60

#  curl https://master:4433/classifier-api/v1/groups --cert /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem --key /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json"
  CURL_OPTS='--cert /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem --key /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem'
  CURL_OPTS_CONTENT='-H "Content-Type:application/json"'
  echo "** Updating Node Classifier Classes"
  curl $CURL_OPTS -X POST https://master:4433/classifier-api/v1/update-classes

#curl $CURL_OPTS -H "Content-Type:application/json" -d '{
#    "name": "TEST",
#    "parent": "00000000-0000-4000-8000-000000000000",
#    "classes": {
#        "epel": {}
#    }
#}' https://master:4433/classifier-api/v1/groups ; echo


  #/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  #nodegroup:add[cm4_embedded,profile::cloudera::agent4_server_embedded,skip] \
  #nodegroup:add[cm4_mysql,profile::cloudera::agent4_server_mysql,skip] \
  #nodegroup:add[cm4_postgresql,profile::cloudera::agent4_server_postgresql,skip] \
  #nodegroup:add[cm5_embedded,profile::cloudera::agent5_server_embedded,skip] \
  #nodegroup:add[cm5_mysql,profile::cloudera::agent5_server_mysql,skip] \
  #nodegroup:add[cm5_postgresql,profile::cloudera::agent5_server_postgresql,skip]
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm4_embedded",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent4_server_embedded": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm4_mysql",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent4_server_mysql": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm4_postgresql",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent4_server_postgresql": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_embedded",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5_server_embedded": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_mysql",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5_server_mysql": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_postgresql",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5_server_postgresql": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo

  #/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  #nodegroup:add[cm5_noparcels_gplextras_cdh5,profile::cloudera::agent5_noparcels_gplextras_cdh5,skip] \
  #nodegroup:add[cm5_noparcels_gplextras_cdh4,profile::cloudera::agent5_noparcels_gplextras_cdh4,skip]
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_noparcels_gplextras_cdh4",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5_noparcels_gplextras_cdh4": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_noparcels_gplextras_cdh5",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5_noparcels_gplextras_cdh5": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo

  #/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  #nodegroup:add[debian,locales,skip] \
  #nodegroup:addclass[debian,apt,skip] \
  #nodegroup:addclassparam[debian,apt,proxy_host,proxy] \
  #nodegroup:addclassparam[debian,apt,proxy_port,3128] \
  #node:add[debian6,debian,,skip] \
  #node:addgroup[debian6,debian] \
  #node:add[debian7,debian,,skip] \
  #node:addgroup[debian7,debian] \
  #node:add[ubuntu1004,debian,,skip] \
  #node:addgroup[ubuntu1004,debian] \
  #node:add[ubuntu1204,debian,,skip] \
  #node:addgroup[ubuntu1204,debian] \
  #node:add[ubuntu1404,debian,,skip] \
  #node:addgroup[ubuntu1404,debian]
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "debian",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "apt": {
        "proxy_host": "proxy",
        "proxy_port": "3128"
      },
      "locales": {}
    },
    "rule": [
      "or",
      [ "=", "name", "debian6" ],
      [ "=", "name", "debian7" ],
      [ "=", "name", "ubuntu1004" ],
      [ "=", "name", "ubuntu1204" ],
      [ "=", "name", "ubuntu1404" ]
    ]
  }' https://master:4433/classifier-api/v1/groups ; echo

  #/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  #nodegroup:add[redhat,selinux,skip] \
  #nodegroup:addclassparam[redhat,selinux,mode,disabled] \
  #node:add[centos5,redhat,,skip] \
  #node:addgroup[centos5,redhat] \
  #node:add[centos6,redhat,,skip] \
  #node:addgroup[centos6,redhat]
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "redhat",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "selinux": {
        "mode": "disabled"
      }
    },
    "rule": [
      "or",
      [ "=", "name", "centos5" ],
      [ "=", "name", "centos6" ]
    ]
  }' https://master:4433/classifier-api/v1/groups ; echo
fi
