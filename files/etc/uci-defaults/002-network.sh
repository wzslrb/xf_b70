#!/bin/sh

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
#service network restart

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
#service dnsmasq restart
logger -t "【网络】" "初始化network dhcp"

uci add_list firewall.@zone[0].network='lcrm2'
uci add_list firewall.@zone[1].network='wan2'
uci commit firewall
#service firewall reload
logger -t "【网络】" "初始化防火墙wan2 lcrm2"

echo "重设无线" >> /mnt/sda1/112.txt

[ -f "/etc/config/wireless" ] || {
	logger -t "【网络】" "重设无线失败，没有配置文件"
	#touch /etc/config/wireless
	exit 0
}
uci -q batch <<-EOF >/dev/null
	set wireless.radio0.country=CN
	set wireless.radio0.channel='9'
	set wireless.radio0.txpower=9
	set wireless.radio1.country=CN
	set wireless.radio1.disabled='1'
	delete wireless.@wifi-iface[0]
	delete wireless.@wifi-iface[0]
	delete wireless.@wifi-iface[0]
	delete wireless.@wifi-iface[0]
	delete wireless.default_radio0
	delete wireless.default_radio1
	set wireless.wf0=wifi-iface
	set wireless.wf0.device='radio0'
	set wireless.wf0.mode='ap'
	set wireless.wf0.network='lcrm2'
	set wireless.wf0.ssid='7907298'
	set wireless.wf0.encryption='psk2'
	set wireless.wf0.key='666666666'
	set wireless.wf1=wifi-iface
	set wireless.wf1.device='radio0'
	set wireless.wf1.mode='ap'
	set wireless.wf1.encryption='none'
	set wireless.wf1.ssid='先拿馒头再打菜不得劲'
	set wireless.wf1.network='lan'
	set wireless.wf2=wifi-iface
	set wireless.wf2.device='radio0'
	set wireless.wf2.mode='ap'
	set wireless.wf2.encryption='none'
	set wireless.wf2.ssid='打完菜回头拿馒头？'
	set wireless.wf2.network='lan'
	set wireless.wf3=wifi-iface
	set wireless.wf3.device='radio0'
	set wireless.wf3.mode='ap'
	set wireless.wf3.encryption='none'
	set wireless.wf3.ssid='哎！都不得劲。咋整呢'
	set wireless.wf3.network='lan'
	commit wireless
EOF
logger -t "【网络】" "重设无线配置文件"
#/etc/init.d/network reload | tee -ai /mnt/sda1/112.txt
#wifi down
#wifi up
exit 0
