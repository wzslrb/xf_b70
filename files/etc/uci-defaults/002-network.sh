#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0

uci -q batch <<-EOF >/dev/null
	set network.lan=interface
	set network.lan.type='bridge'
	set network.lan.proto='static'
	set network.lan.netmask='255.255.255.0'
	set network.lan._orig_ifname='lan1 lan3 ra0 rai0 wlan0'
	set network.lan._orig_bridge='true'
	set network.lan.ipaddr='192.168.200.1'
	set network.lan.ifname='lan1 lan3'

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
#service network restart
#cachesize='0' 不缓冲
uci -q batch <<-EOF >/dev/null
	set dhcp.@dnsmasq[0].cachesize='0'
	delete dhcp.@dnsmasq[0].boguspriv
	delete dhcp.@dnsmasq[0].filterwin2k
	delete dhcp.@dnsmasq[0].nonegcache
	set dhcp.lan=dhcp
	set dhcp.lan.interface='lan'
	set dhcp.lan.start='100'
	set dhcp.lan.limit='150'
	set dhcp.lan.leasetime='12h'
	delete dhcp.lan.dhcpv6
	delete dhcp.lan.ra
	delete dhcp.lan.ra_slaac
        del_list dhcp.lan.ra_flags='managed-config'
        del_list dhcp.lan.ra_flags='other-config'
	set dhcp.wan=dhcp
	set dhcp.wan.ignore='1'
	set dhcp.lcrm2=dhcp
	set dhcp.lcrm2.start='100'
	set dhcp.lcrm2.leasetime='12h'
	set dhcp.lcrm2.limit='150'
	set dhcp.lcrm2.interface='lcrm2'
	commit dhcp
EOF

#service dnsmasq restart
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-初始化network dhcp" >> /mnt/sda1/112.txt

uci add_list firewall.@zone[0].network='lcrm2'
uci add_list firewall.@zone[1].network='wan2'
uci commit firewall
#service firewall reload
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-初始化防火墙wan2 lcrm2" >> /mnt/sda1/112.txt

exit 0
