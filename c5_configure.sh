#!/bin/bash
USE_PROXY=y

echo "** Install curl."
puppet resource package curl ensure=present

echo "** Install the Cloudera Manager license key."
curl -u "admin:admin" \
  -F license=@/vagrant/c5_license.key \
  http://localhost:7180/api/v6/cm/license
echo

if [ "$USE_PROXY" == "y" ]; then
  echo "** Configure CM to use the local squid proxy for parcel downloads."
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
  echo
fi

