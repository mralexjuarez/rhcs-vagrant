#!/bin/bash

yum -y --disablerepo=epel* install cmirror cman rgmanager ricci python-repoze-who-friendlyform luci iscsi-initiator-utils lvm2-cluster gfs2-utils ccs mysql-server

yum -y install http://josephq.com/rs_fence-1.1-0.x86_64.rpm

#Configure iscsi - on both nodes
modprobe scsi_transport_iscsi
chkconfig iscsi on
iscsiadm -m discoverydb -t sendtargets -p storage -D
iscsiadm –mode node –targetname iqn.storage:target0 –portal storage --login
service iscsi restart
service iscsi status

# set REGION to your region, i.e.
REGION="ORD"
sed -i s/"^region=.*"/"region=$REGION"/g /etc/rs_fence

# set LOGIN to your cloud account name, i.e.
LOGIN="mycloudaccount"
sed -i s/"^login=.*"/"login=$LOGIN"/g /etc/rs_fence

# Fencing
chkconfig rs_fence on
service rs_fence start

# Ricci
echo "rikkirikkirikki" | passwd ricci --stdin
chkconfig ricci on
service ricci start
