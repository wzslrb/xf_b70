#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="无线共享"

[ ! -f /etc/config/wireless ] && {
	logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "wifi config初始化无线配置文件"
	wifi config
	sleep 1
}

if [ -f "/etc/config/wireless" ]; then {
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
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "diy无线配置文件"
}
else
{
	logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "★★★★★没有配置文件"
	[ -f /mnt/sda1/lost\+found/wireless ] && {
		cp -pf /mnt/sda1/lost\+found/wireless /etc/config/
		logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "恢复备份的wireless"
	}
}
fi

exit 0
