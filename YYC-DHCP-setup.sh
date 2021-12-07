#!/bin/bash
# Update yum
HNAME=/etc/hostname
IP_DIR=/etc/sysconfig/network-scripts/ifcfg-ens33
#DHCP_DAE=/usr/sbin/dhcpd
#DHCP_CONF=/etc/dhcp/dhcpd.conf



echo "YYC-DHCP.instantsoft.ca" > $HNAME
#yum update -y

#yum install dhcp -y
# CONFIGURING DHCP
up_config () {
    local TARGET_KEY ="$1"
    local REPLACEMENT_VALUE="$2"
    sed -c -i "s/\($TARGET_KEY *= *\).*/\1$REPLACEMENT_VALUE/" $IP_DIR
}
up_config "TYPE" "Ethernet"
up_config "BOOTPROTO" "static"
up_config "IPV6INIT" "no"
up_config "ONBOOT" "yes"
echo "IPADDR=192.168.100.2" >> $IP_DIR
echo "NETMASK=255.255.255.0" >> $IP_DIR
echo "GATEWAY=192.168.100.1" >> $IP_DIR
echo "DNS=192.168.100.1" >> $IP_DIR
# Restarting Services
# service dhcpd restart
# service dhcpd stop
# service dhcpd start
# service dhcpd status

# systemctl enable dhcpd.service

### https://it-garry.medium.com/shell-scripts-thatll-automate-software-installation-on-your-linux-server-part-ii-d3fb635fe013 ###
### https://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script/2464883#2464883 ###
