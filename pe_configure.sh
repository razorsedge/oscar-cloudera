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
nodegroup:add[cm4_embeded,profile::cloudera::agent4_server_embeded,skip] \
nodegroup:add[cm4_mysql,profile::cloudera::agent4_server_mysql,skip] \
nodegroup:add[cm4_postgresql,profile::cloudera::agent4_server_postgresql,skip] \
nodegroup:add[cm5_embeded,profile::cloudera::agent5_server_embeded,skip] \
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

  /opt/puppet/bin/puppet module install attachmentgenie/locales
  /opt/puppet/bin/puppet module install spiette/selinux
  service pe-puppetserver restart
  sleep 60

#  curl https://master:4433/classifier-api/v1/groups --cert /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem --key /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json"
  curl https://master:4433/classifier-api/v1/update-classes -d key=value --cert /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem --key /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json"

  /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  nodegroup:add[cm4_embeded,profile::cloudera::agent4_server_embeded,skip] \
  nodegroup:add[cm4_mysql,profile::cloudera::agent4_server_mysql,skip] \
  nodegroup:add[cm4_postgresql,profile::cloudera::agent4_server_postgresql,skip] \
  nodegroup:add[cm5_embeded,profile::cloudera::agent5_server_embeded,skip] \
  nodegroup:add[cm5_mysql,profile::cloudera::agent5_server_mysql,skip] \
  nodegroup:add[cm5_postgresql,profile::cloudera::agent5_server_postgresql,skip]

  /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  nodegroup:add[cm5_noparcels_gplextras_cdh5,profile::cloudera::agent5_noparcels_gplextras_cdh5,skip] \
  nodegroup:add[cm5_noparcels_gplextras_cdh4,profile::cloudera::agent5_noparcels_gplextras_cdh4,skip]

  /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  nodegroup:add[debian,locales,skip] \
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

  /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
  nodegroup:add[redhat,selinux,skip] \
  nodegroup:addclassparam[redhat,selinux,mode,disabled] \
  node:add[centos5,redhat,,skip] \
  node:addgroup[centos5,redhat] \
  node:add[centos6,redhat,,skip] \
  node:addgroup[centos6,redhat]
fi
