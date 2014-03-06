#!/bin/bash

rs_network_bits=$(ip route list | grep eth2.*kernel | cut -d " " -f 1 | egrep -o "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")

## Modify EPEL to exclude troubled package
echo "exclude=python-repoze-who-friendlyform" >> /etc/yum.repos.d/epel.repo

## Install Packages
# Install Pacakges for iSCSI and Luci
/usr/bin/yum -y install iscsi-initiator-utils scsi-target-utils luci

## Set to start at boot
# Chkconfig iSCSI On
/sbin/chkconfig iscsi on
/sbin/chkconfig iscsid on

# Chkconfig tgt on
/sbin/chkconfig tgtd on

# Chkconfig luci on
/sbin/chkconfig luci on 

## Modify Files
# Modify the iSCSI files
echo "InitiatorName=iqn.$(hostname):target0" > /etc/iscsi/initiatorname.iscsi

# Start tgt
/sbin/service tgtd start

# Setup the store
tgtadm --lld iscsi --mode target --op new --tid 101 --targetname iqn.$(hostname):target0
tgtadm --mode logicalunit --op new --tid 101 --lun 1 --backing-store /dev/xvdb

# Allow the two nodes to access the store
tgtadm --mode target --op bind --tid 101 --initiator-address $rs_network_bits.101
tgtadm --mode target --op bind --tid 101 --initiator-address $rs_network_bits.102

## Start Services
# Start iscsid
/sbin/service iscsid start

# Start Luci
/sbin/service luci start
