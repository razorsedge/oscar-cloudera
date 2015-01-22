#!/bin/sh
/opt/puppet/bin/puppet config set modulepath /etc/puppetlabs/puppet/modules:/modules:/opt/puppet/share/puppet/modules --section main

cp -p /vagrant/pe_license.key /etc/puppetlabs/license.key

/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[profile::cloudera::agent5_server,skip] \
nodeclass:add[profile::cloudera::agent4_server,skip] \
nodeclass:add[profile::cloudera::agent5_noparcels_gplextras_cdh5,skip] \
nodeclass:add[profile::cloudera::agent5_noparcels_gplextras_cdh4,skip] \
nodegroup:add[agent5_server,profile::cloudera::agent5_server,skip] \
nodegroup:add[agent4_server,profile::cloudera::agent4_server,skip] \
nodegroup:add[agent5_noparcels_gplextras_cdh5,profile::cloudera::agent5_noparcels_gplextras_cdh5,skip] \
nodegroup:add[agent5_noparcels_gplextras_cdh4,profile::cloudera::agent5_noparcels_gplextras_cdh4,skip]

/opt/puppet/bin/puppet module install attachmentgenie/locales
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[locales,skip] \
nodegroup:add[debian,locales,skip] \
node:add[debian6,debian,,skip] \
node:addgroup[debian6,debian] \
node:add[debian7,debian,,skip] \
node:addgroup[debian7,debian]

/opt/puppet/bin/puppet module install spiette/selinux
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[selinux,skip] \
nodegroup:add[rhel,selinux,skip] \
nodegroup:addclassparam[rhel,selinux,mode,disabled] \
node:add[centos5,rhel,,skip] \
node:addgroup[centos5,rhel] \
node:add[centos6,rhel,,skip] \
node:addgroup[centos6,rhel]

