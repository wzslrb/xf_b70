#!/bin/sh

uci set dhcp.lan=dhcp
uci set dhcp.lan.interface='lan'
uci set dhcp.lan.start='100'
uci set dhcp.lan.limit='150'
uci set dhcp.lan.leasetime='12h'

uci set dhcp.wan=dhcp
uci set dhcp.wan.interface='wan'
uci set dhcp.wan.ignore='1'

uci set dhcp.lcrm2=dhcp
uci set dhcp.lcrm2.start='100'
uci set dhcp.lcrm2.leasetime='12h'
uci set dhcp.lcrm2.limit='150'
uci set dhcp.lcrm2.interface='lcrm2'

uci commit dhcp
service dnsmasq restart
