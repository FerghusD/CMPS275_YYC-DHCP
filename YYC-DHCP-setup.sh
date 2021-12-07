#!/bin/bash
HNAME=/etc/hostname
IP_DIR=/etc/sysconfig/network-scripts/ifcfg-ens33
DHCP_DAE=/usr/sbin/dhcpd
DHCP_CONF=/etc/dhcp/dhcpd.conf



echo "YYC-DHCP.instantsoft.ca" > $HNAME
#yum update -y

yum install dhcp -y
mv "$IP_DIR" "$IP_DIR.bak"
    rm $IP_DIR
# CONFIGURING IP SHIT
up_config () {
    local KEY ="$1"
    local NEWVALUE="$2"
    cat "$IP_DIR.bak" | grep -v "^${KEY}${'='}" >> "$IP_DIR"
    echo "${KEY}${'='}${NEWVALUE}" >> "$IP_DIR"
}
up_config "TYPE" "Ethernet"
up_config "BOOTPROTO" "static"
up_config "IPV6INIT" "no"
up_config "ONBOOT" "yes"
echo "IPADDR=192.168.100.2" >> $IP_DIR
echo "NETMASK=255.255.255.0" >> $IP_DIR
echo "GATEWAY=192.168.100.1" >> $IP_DIR
echo "DNS1=192.168.100.1" >> $IP_DIR

systemctl restart network

service start dhcpd
#CONFIGURING DHCP SHIT
echo "default-lease-time 600;" >> $DHCP_CONF
echo "max-lease-time 600;" >> $DHCP_CONF
echo "option domain-name 'instantsoft.ca';" >> $DHCP_CONF
echo "subnet 192.168.100.0 netmask 255.255.255.0;" >> $DHCP_CONF
echo "range 192.168.100.10 192.168.100.100;" >> $DHCP_CONF
echo "option routers 192.168.100.1;" >> $DHCP_CONF
echo "option domain-name-servers 192.168.100.1" >> $DHCP_CONF

# Restarting Services
service dhcpd restart
service enable dhcpd
service dhcpd status

# systemctl enable dhcpd.service

### https://it-garry.medium.com/shell-scripts-thatll-automate-software-installation-on-your-linux-server-part-ii-d3fb635fe013 ###
### https://stackoverflow.com/questions/2464760/modify-config-IP_DIR-using-bash-script/2464883#2464883 ###
