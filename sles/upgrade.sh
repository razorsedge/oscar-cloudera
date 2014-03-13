#!/bin/bash
if [ -f /.vagrant1 ]; then exit 0; fi
rm -f /etc/zypp/repos.d/*
#zypper --non-interactive addrepo -f -r /root/repo/SUSE-Linux-Enterprise-Server-11-SP2_11.2.1-1.234.repo
#zypper --non-interactive addrepo -f -r /root/repo/SUSE-Linux-Enterprise-Software-Development-Kit-11-SP2_11.2.1-1.66.repo
zypper --non-interactive addrepo -f -r /root/repo/SUSE-Linux-Enterprise-Server-11-SP3_11.3.1-1.138.repo
zypper --non-interactive addrepo -f -r /root/repo/SUSE-Linux-Enterprise-Software-Development-Kit-11-SP3_11.3.1-1.69.repo
zypper --non-interactive refresh
exit 0
zypper --quiet --non-interactive dist-upgrade --auto-agree-with-licenses
cat <<EOFF >/etc/init.d/vboxadd_compile
#!/bin/sh
# chkconfig: 35 30 70
# description: VirtualBox Linux Additions kernel modules
#
### BEGIN INIT INFO
# Provides:       vboxadd_compile
# Required-Start:
# Required-Stop:
# Default-Start:  3
# Default-Stop:
# Description:    VirtualBox Linux Additions kernel modules
### END INIT INFO

if [ -f /.vagrant2 ]; then
  insserv -r /etc/init.d/vboxadd_compile
  rm -f /etc/init.d/vboxadd_compile
else
  /sbin/service vboxadd setup
  insserv -r /etc/init.d/vboxadd_compile
  rm -f /etc/init.d/vboxadd_compile
  touch /.vagrant2
  /sbin/reboot
fi
EOFF
chmod 0755 /etc/init.d/vboxadd_compile
insserv /etc/init.d/vboxadd_compile
touch /.vagrant1
reboot
