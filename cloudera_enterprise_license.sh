#!/bin/sh

puppet resource package curl ensure=present

echo "Install the Cloudera Manager license key."
curl -u "admin:admin" \
  -F license=@/vagrant/puppetlabs-c5_dev_cloudera_enterprise_license.txt \
  http://localhost:7180/api/v6/cm/license

echo "Configure CM to use the local squid proxy for parcel downloads."
curl -X PUT -u "admin:admin" \
 -H "Content-Type:application/json" \
 -d '{
   "items" : [ {
     "name" : "PARCEL_PROXY_PORT",
     "value" : "3128"
   }, {
     "name" : "PARCEL_PROXY_SERVER",
     "value" : "proxy"
   } ]
 }' \
 http://localhost:7180/api/v6/cm/config

