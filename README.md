This is the test harness for creating the certification environment for Cloudera's C5 validation of the [razorsedge/cloudera](https://forge.puppetlabs.com/razorsedge/cloudera/) Puppet module on [Puppet Enterprise](https://puppetlabs.com/puppet/puppet-enterprise).

Requires [Vagrant](http://www.vagrantup.com/) and [Oscar](https://github.com/adrienthebo/oscar).  Also requires a [caching proxy](http://www.squid-cache.org/) at hostname "proxy" and port "3128" as this setup will pull down over 3GB of Cloudera and OS packages.  Edit `cloudera_enterprise_license.sh` if this is not what you want and do not run the next snippet of code.

```
vagrant plugin install vagrant-proxyconf

# This will overwrite your global Vagrantfile.  Be careful if this is not
# what you want.
cat <<EOF >~/.vagrant.d/Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # https://github.com/tmatilai/vagrant-proxyconf
  if defined?(VagrantPlugins::ProxyConf)
    config.proxy.http = "http://proxy:3128/"
    config.proxy.https = "http://proxy:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,master"
  end
end
EOF
```

This setup will require a machine with several CPUs (8), 18GB of RAM, and 35GB disk. Plan on going out for lunch after firing off `vagrant up` as there will be 4.6GB of baseboxen and PE installers to download.

# Setup
Clone the git repo.
```
git clone https://github.com/razorsedge/oscar-cloudera.git cloudera
cd cloudera
git submodule init
git submodule update
```

# Add License Keys
Install the PE license key in file `pe_license.key`.  Install the CM license key in file `puppetlabs-c5_dev_cloudera_enterprise_license.txt`.

# Fire Up the VMs
```
vagrant up --no-provision
vagrant provision
```

# Prepare Puppet
Log in to the Puppet Console.
Add each host to the Group `agent5_server` or whichever profile is being tested.

# Install License Keys
Log in to each VM and install the CM license key.
```
vagrant ssh centos59
sudo /vagrant/cloudera_enterprise_license.sh
sudo tar zcvf /vagrant/puppetlabs-razorsedge_cloudera-2.0.0-c5_`hostname`.tar.gz /var/log
```

# Connect to Cloudera Manager
Connect to each Cloudera Manager Server instance to send a diagnostic bundle.

- http://vagrant_server:7180/
- http://vagrant_server:2202/
- http://vagrant_server:2204/
- http://vagrant_server:2206/
- http://vagrant_server:2208/
- http://vagrant_server:2210/
- http://vagrant_server:2212/

# License

Please see LICENSE file.

# Copyright

Copyright (C) 2014 Mike Arnold <mike@razorsedge.org>

[razorsedge/oscar-cloudera on GitHub](https://github.com/razorsedge/oscar-cloudera)

