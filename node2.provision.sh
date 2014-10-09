#!/bin/bash

yum -y --disablerepo=epel* install cmirror cman rgmanager ricci python-repoze-who-friendlyform luci iscsi-initiator-utils lvm2-cluster gfs2-utils ccs mysql-server mysql

#Configure LVM Locking
#sed -i -e "s/^\s*locking_type = 1/    locking_type = 3/g" /etc/lvm/lvm.conf
lvmconf --enable-cluster

#Copy some files to in place
cp /vagrant/files/hosts /etc/hosts
cp /vagrant/files/motd /etc/motd

#Configure iscsi - on both nodes
modprobe scsi_transport_iscsi
chkconfig iscsi on
iscsiadm -m discoverydb -t sendtargets -p storage -D
iscsiadm –mode node –targetname iqn.storage:target0 –portal storage --login
service iscsi restart
service iscsi status

# Fencing
pip-python install hgtools
pip-python install pyrax
curl -o /usr/sbin/fence_pyrax https://raw.githubusercontent.com/shannonmitchell/rhcs_in_rs_cloud/master/deploy_scripts/fence_pyrax
chmod u+x /usr/sbin/fence_pyrax

# Ricci
echo "rikkirikkirikki" | passwd ricci --stdin
chkconfig ricci on
service ricci start
