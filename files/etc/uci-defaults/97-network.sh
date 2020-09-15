#!/bin/sh

uci set network.lan=interface
uci set network.lan.type='bridge'
uci set network.lan.proto='static'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan._orig_ifname='lan1 lan2 lan3 ra0 rai0 wlan0'
uci set network.lan._orig_bridge='true'
uci set network.lan.ipaddr='192.168.200.1'
uci set network.lan.ifname='lan1 lan3'

uci set network.lcrm2=interface
uci set network.lcrm2.type='bridge'
uci set network.lcrm2.proto='static'
uci set network.lcrm2.ipaddr='192.168.199.1'
uci set network.lcrm2.netmask='255.255.255.0'
uci set network.lcrm2._orig_ifname='lan3'
uci set network.lcrm2._orig_bridge='true'
uci set network.lcrm2.ifname='lan3'

uci set network.wan2=interface
uci set network.wan2.proto='static'
uci set network.wan2.ifname='lan2'
uci set network.wan2.ipaddr='192.168.1.222'
uci set network.wan2.netmask='255.255.255.0'
uci set network.wan2.gateway='192.168.1.1'
uci set network.wan2.dns='192.168.1.1'
uci commit network
service network restart
