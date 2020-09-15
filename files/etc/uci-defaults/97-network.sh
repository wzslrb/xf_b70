#!/bin/sh

[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt
echo "初始化network" >> /mnt/sda1/112.txt
uci -q batch <<-EOF >/dev/null
	set network.lan=interface
	set network.lan.type='bridge'
	set network.lan.proto='static'
	set network.lan.netmask='255.255.255.0'
	set network.lan._orig_ifname='lan1 lan3 ra0 rai0 wlan0'
	set network.lan._orig_bridge='true'
	set network.lan.ipaddr='192.168.200.1'
	set network.lan.ifname='lan1 lan3'
	delete dhcp.lan.dhcpv6
	delete dhcp.lan.ra
	delete dhcp.lan.ra_slaac
	delete dhcp.lan.ra_flags

	set network.lcrm2=interface
	set network.lcrm2.type='bridge'
	set network.lcrm2.proto='static'
	set network.lcrm2.ipaddr='192.168.199.1'
	set network.lcrm2.netmask='255.255.255.0'
	set network.lcrm2._orig_ifname='lan3'
	set network.lcrm2._orig_bridge='true'
	set network.lcrm2.ifname='lan3'

	set network.wan2=interface
	set network.wan2.proto='static'
	set network.wan2.ifname='lan2'
	set network.wan2.ipaddr='192.168.1.222'
	set network.wan2.netmask='255.255.255.0'
	set network.wan2.gateway='192.168.1.1'
	set network.wan2.dns='192.168.1.1'
	commit network
EOF
service network restart
exit 0
