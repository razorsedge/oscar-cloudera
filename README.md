This is the test harness for creating the certification environment for
Cloudera's C5 validation.

Requires [Vagrant](http://www.vagrantup.com/) and [Oscar](https://github.com/adrienthebo/oscar).

These are the commands that created the initial configuration in this git repo.

```
vagrant oscar init

vagrant oscar init-vms --pe-version=3.2.0 \
--master master=centos-64-x64-vbox4210-nocm \
--agent centos59=centos-59-x64-vbox4210-nocm \
--agent centos64=centos-64-x64-vbox4210-nocm \
--agent debian6=debian-607-x64-vbox4210-nocm \
--agent debian7=debian-70rc1-x64-vbox4210-nocm \
--agent sles11=sles-11sp1-x64-vbox4210-nocm \
--agent ubuntu1004=ubuntu-server-10044-x64-vbox4210-nocm \
--agent ubuntu1204=ubuntu-server-12042-x64-vbox4210-nocm
```

```
git clone https://github.com/razorsedge/oscar-cloudera.git .
```

Install PE license key in file pe_license.key.
Install CM license key in file puppetlabs-c5_dev_cloudera_enterprise_license.txt.

```
vagrant up --no-provision
vagrant provision
```

Add fqdn to /etc/hosts:
sles11
centos59

Log in to the Puppet Console.
Add each host to the Group `agent5_server`.

Log in to each VM and install the CM license key.
```
/vagrant/cloudera_enterprise_license.sh
```

