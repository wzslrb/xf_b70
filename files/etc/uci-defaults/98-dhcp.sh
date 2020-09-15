#!/bin/sh

uci -q batch <<-EOF >/dev/null
	set dhcp.lan=dhcp
	set dhcp.lan.interface='lan'
	set dhcp.lan.start='100'
	set dhcp.lan.limit='150'
	set dhcp.lan.leasetime='12h'
	set dhcp.wan=dhcp
	set dhcp.wan.ignore='1'
	set dhcp.lcrm2=dhcp
	set dhcp.lcrm2.start='100'
	set dhcp.lcrm2.leasetime='12h'
	set dhcp.lcrm2.limit='150'
	set dhcp.lcrm2.interface='lcrm2'
	commit dhcp
EOF
service dnsmasq restart
