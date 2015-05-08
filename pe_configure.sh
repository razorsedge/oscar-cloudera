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
nodeclass:add[profile::cloudera::agent4_server,skip] \
nodeclass:add[profile::cloudera::agent4,skip] \
nodeclass:add[profile::cloudera::agent5_server,skip] \
nodeclass:add[profile::cloudera::agent5,skip] \
nodegroup:add[cm4_server,profile::cloudera::agent4_server,skip] \
nodegroup:add[cm4_agent,profile::cloudera::agent4,skip] \
nodegroup:add[cm5_server,profile::cloudera::agent5_server,skip] \
nodegroup:add[cm5_agent,profile::cloudera::agent5,skip]

/opt/puppet/bin/puppet module install spiette/selinux
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production \
nodeclass:add[selinux,skip] \
nodegroup:add[redhat,selinux,skip] \
nodegroup:addclassparam[redhat,selinux,mode,disabled] \
node:add[node1,redhat,,skip] \
node:addgroup[node1,redhat] \
node:add[node2,redhat,,skip] \
node:addgroup[node2,redhat] \
node:add[node3,redhat,,skip] \
node:addgroup[node3,redhat] \
node:add[node4,redhat,,skip] \
node:addgroup[node4,redhat]
else
  # PE >= 3.7.x
  /opt/puppet/bin/puppet config set basemodulepath /etc/puppetlabs/puppet/modules:/modules:/opt/puppet/share/puppet/modules --section main
  #mkdir -p /var/lib/hiera
  #echo -e "---\ncloudera::cm5::autoupgrade: true" >/var/lib/hiera/global.yaml
  cat <<EOF >>/etc/puppetlabs/puppet/environments/production/manifests/site.pp
# https://ask.puppetlabs.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  \$allow_virtual_packages = hiera('allow_virtual_packages',false)
  Package {
    allow_virtual => \$allow_virtual_packages,
  }
}
EOF

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


  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm4_server",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent4_server": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm4_agent",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent4": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_server",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5_server": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo
  curl $CURL_OPTS -H "Content-Type:application/json" -d '{
    "name": "cm5_agent",
    "parent": "00000000-0000-4000-8000-000000000000",
    "classes": {
      "profile::cloudera::agent5": {}
    }
  }' https://master:4433/classifier-api/v1/groups ; echo

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
      [ "=", "name", "master" ],
      [ "=", "name", "node1" ],
      [ "=", "name", "node2" ],
      [ "=", "name", "node3" ],
      [ "=", "name", "node4" ]
    ]
  }' https://master:4433/classifier-api/v1/groups ; echo
fi
