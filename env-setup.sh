#!/bin/bash

# Environment setup for each server

## IPTables
## We are going to open up the 192.16.X.X network between all servers.

# Determine our subnet
rs_network=$(ip route list | grep eth2.*kernel | cut -d " " -f 1)

# Just the bits
rs_network_bits=$(ip route list | grep eth2.*kernel | cut -d " " -f 1 | egrep -o "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")

# Set the last for each of the nodes
node1=101
node2=102
storage=50
host=$(hostname)

# Create the iptables rules
if [ !$(iptables -N CLUSTER-RULES) ]
	then
		echo "### Adding IP Tables Rules"
		iptables -I INPUT 1 -j CLUSTER-RULES
		iptables -I CLUSTER-RULES -s $rs_network -j ACCEPT
		iptables-save > /etc/sysconfig/iptables
	else
		echo "# Skipping iptables"
fi

# Edit the Hosts File
if [ $(grep -c "^## RHCS Cluster Nodes ##" /etc/hosts) == 0 ]
	then
		echo "### Adding entries to /etc/hosts"
		echo "## RHCS Cluster Nodes ##" >> /etc/hosts
		echo "$rs_network_bits.101 node1" >> /etc/hosts
		echo "$rs_network_bits.102 node2" >> /etc/hosts
		echo "$rs_network_bits.50 storage" >> /etc/hosts
	else
		echo "# Skipping /etc/hosts is already updated."
fi

## Update eth2 so that it reflects the following
## X.X.X.101 - node1
## X.X.X.102 - node2
## X.X.X.50 - storage

if [ $(grep -c "#UPDATED" /etc/sysconfig/network-scripts/ifcfg-eth2) == 0 ]
	then
		ifdown eth2
		sed -i s/"^IPADDR=.*"/"IPADDR=$rs_network_bits.$(eval "echo \$${host}")"/ /etc/sysconfig/network-scripts/ifcfg-eth2
		echo "#UPDATED" >> /etc/sysconfig/network-scripts/ifcfg-eth2
		ifup eth2
	else
		echo "# Skipping NIC Setup"
fi

### Execute server specific script.
#echo "Running $host scripts"
#/vagrant/$host.provision.sh
