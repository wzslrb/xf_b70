#!/bin/sh

[ -f "/etc/config/wireless" ] || exit 0
echo "重设无线" >> /mnt/sda1/112.txt
uci set wireless.radio0.country=CN
uci set wireless.radio0.channel='9'
uci set wireless.radio0.txpower=9
uci set wireless.radio1.country=CN
uci set wireless.radio1.disabled='1'
uci delete wireless.@wifi-iface[0]
uci delete wireless.@wifi-iface[0]
uci delete wireless.@wifi-iface[0]
uci delete wireless.@wifi-iface[0]
uci delete wireless.default_radio0
uci delete wireless.default_radio1
uci set wireless.wf0=wifi-iface
uci set wireless.wf0.device='radio0'
uci set wireless.wf0.mode='ap'
uci set wireless.wf0.network='lcrm2'
uci set wireless.wf0.ssid='7907298'
uci set wireless.wf0.encryption='psk2'
uci set wireless.wf0.key='666666666'
uci set wireless.wf1=wifi-iface
uci set wireless.wf1.device='radio0'
uci set wireless.wf1.mode='ap'
uci set wireless.wf1.encryption='none'
uci set wireless.wf1.ssid='先拿馒头再打菜不得劲'
uci set wireless.wf1.network='lan'
uci set wireless.wf2=wifi-iface
uci set wireless.wf2.device='radio0'
uci set wireless.wf2.mode='ap'
uci set wireless.wf2.encryption='none'
uci set wireless.wf2.ssid='打完菜回头拿馒头？'
uci set wireless.wf2.network='lan'
uci set wireless.wf3=wifi-iface
uci set wireless.wf3.device='radio0'
uci set wireless.wf3.mode='ap'
uci set wireless.wf3.encryption='none'
uci set wireless.wf3.ssid='哎！都不得劲。咋整呢'
uci set wireless.wf3.network='lan'
uci commit wireless
/etc/init.d/network reload | tee -ai /mnt/sda1/112.txt
wifi down
wifi up
