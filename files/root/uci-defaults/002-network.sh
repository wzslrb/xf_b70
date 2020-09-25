#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="网络"


cp /etc/config/network /mnt/sda1/temp
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "备份/etc/config/network /mnt/sda1/temp"
uci -q batch <<-EOF >/dev/null
	set network.lan._orig_ifname='lan1 lan3 ra0 rai0 wlan0'
	set network.lan._orig_bridge='true'
	set network.lan.ipaddr='192.168.200.1'
	set network.lan.ifname='lan1'
	set network.lan.delegate='0'	#使用内置的 IPv6 管理
	set network.lcrm2=interface
	set network.lcrm2.type='bridge'
	set network.lcrm2.proto='static'
	set network.lcrm2.ipaddr='192.168.199.1'
	set network.lcrm2.netmask='255.255.255.0'
	set network.lcrm2._orig_ifname='lan3'
	set network.lcrm2._orig_bridge='true'
	set network.lcrm2.ifname='lan3'
	set network.lcrm2.delegate='0'	#使用内置的 IPv6 管理
	set network.wan.auto='0'	#开机自动运行
	set network.wan6.auto=0		#开机自动运行
	set network.wan6.delegate=0	#使用内置的 IPv6 管理
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

uci -q batch <<-EOF >/dev/null
	delete dhcp.@dnsmasq[0].boguspriv
	delete dhcp.@dnsmasq[0].filterwin2k
	delete dhcp.@dnsmasq[0].nonegcache
	set dhcp.lcrm2=dhcp
	set dhcp.lcrm2.start='100'
	set dhcp.lcrm2.leasetime='12h'
	set dhcp.lcrm2.limit='150'
	set dhcp.lcrm2.interface='lcrm2'
	commit dhcp
EOF

#service dnsmasq restart
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "初始化network dhcp"

uci add_list firewall.@zone[0].network='lcrm2'
uci add_list firewall.@zone[1].network='wan2'
uci commit firewall
#service firewall reload
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "初始化防火墙wan2 lcrm2"

exit 0
