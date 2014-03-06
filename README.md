vagrant oscar init

vagrant oscar init-vms --pe-version=3.1.2 \
--master master=centos-64-x64-vbox4210-nocm \
--agent centos59=centos-59-x64-vbox4210-nocm \
--agent centos64=centos-64-x64-vbox4210-nocm \
--agent debian6=debian-607-x64-vbox4210-nocm \
--agent debian7=debian-70rc1-x64-vbox4210-nocm \
--agent sles11=sles-11sp1-x64-vbox4210-nocm \
--agent ubuntu1004=ubuntu-server-10044-x64-vbox4210-nocm \
--agent ubuntu1204=ubuntu-server-12042-x64-vbox4210-nocm

# edit config/roles.yaml and config/vms.yaml
# rsync in puppet dir
