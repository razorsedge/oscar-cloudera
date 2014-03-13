#!/bin/sh
/opt/puppet/bin/puppet config set modulepath /modules:/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules --section main

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

