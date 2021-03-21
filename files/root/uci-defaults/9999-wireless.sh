#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="无线共享"

[ ! -f /etc/config/wireless ] && {
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "wifi config初始化无线配置文件"
	wifi config
	sleep 1
}

if [ -f "/etc/config/wireless" ]; then {
uci -q batch <<-EOF >/dev/null
	set wireless.radio0.country=CN
	set wireless.radio0.channel='9'
	set wireless.radio0.legacy_rates=1
	set wireless.radio0.mu_beamformer=0
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
	set wireless.wf0.encryption='none'
	set wireless.wf0.hidden='1'
	set wireless.wf1=wifi-iface
	set wireless.wf1.device='radio0'
	set wireless.wf1.mode='ap'
	set wireless.wf1.encryption='none'
	set wireless.wf1.ssid='77820·16500·4400·03820'
	set wireless.wf1.isolate='1'
	set wireless.wf1.network=wan6
	set wireless.wf1.wds=1
	set wireless.wf1.macfilter=allow
	add_list wireless.wf1.maclist=00:00:88:88:00:00
	add_list wireless.wf1.maclist=78:d3:8d:02:7d:4a
	add_list wireless.wf1.maclist=14:9d:09:17:a3:1c
	set wireless.wf2=wifi-iface
	set wireless.wf2.device='radio0'
	set wireless.wf2.mode='ap'
	set wireless.wf2.encryption='none'
	set wireless.wf2.ssid='77820·16500·4400·03820'
	set wireless.wf2.network='lan'
	set wireless.wf2.isolate='1'
	set wireless.wf2.macfilter=deny
	set wireless.wf3=wifi-iface
	set wireless.wf3.device='radio0'
	set wireless.wf3.mode='ap'
	set wireless.wf3.encryption='none'
	set wireless.wf3.ssid='77820·16500·4400·03820'
	set wireless.wf3.isolate='1'
	set wireless.wf3.network='wan'
	set wireless.wf3.wds=1
	set wireless.wf3.macfilter=allow
	add_list wireless.wf3.maclist=00:00:44:44:00:00
	add_list wireless.wf3.maclist=78:d3:8d:02:7d:4a
	add_list wireless.wf3.maclist=14:9d:09:17:a3:1c
	commit wireless
EOF
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "diy无线配置文件"
}
else
{
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "★★★★★没有配置文件"
	[ -f /mnt/sda1/lost\+found/wireless ] && {
		cp -pf /mnt/sda1/lost\+found/wireless /etc/config/
		echo  "${tag}" "【${tit}】$((h4=h4+1))：" "恢复备份的wireless"
	}
}
fi

exit 0
