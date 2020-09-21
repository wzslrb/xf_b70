#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="apfree_Wifidog"
[ -d /mnt/sda1 ] && export log="/mnt/sda1/112.txt" || export log="/tmp/112.txt"

[ -x "/etc/init.d/wifidogx" ] || {
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "错误：未安装apfree-wifidog" >> $log
	exit 0
}

if [ "$(opkg list-installed | grep "^apfree" | sed "/^apfree/s/.*- //g")" != "3.11.1716-4" ]; then {
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "跳过apfree版本" >> $log
}
else
{
	#第二行后面插入pwd
	#apfree-wifidog_4.08.1771-4 修复bug
	#sed -i '2apwd' /etc/init.d/wifidogx
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "更正此版本apfree的/etc/init.d/wifidogx" >> $log
	sed -i '/" "disabled"/s/0/1/g' /etc/init.d/wifidogx
	sed -i '/= "0" ]; then/s/0/1/g' /etc/init.d/wifidogx
	sed -i '/if.*APFREE_/s/-s/! &/g' /etc/init.d/wifidogx
	sed -i '/if.*APFREE_/s/\&/|/g' /etc/init.d/wifidogx
}
fi


#重建apfee目录
[ -d "/mnt/sda1/portal/wifidog" ] && {
	ln -nsf /mnt/sda1/portal/wifidog /www/wifidog
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重建apfee目录" >> $log
}

[ ! -f /etc/config/wifidogx ] && touch /etc/config/wifidogx
uci -q batch <<-EOF >/dev/null
	 set wifidogx.@wifidog[0]=wifidog
	 set wifidogx.@wifidog[0].gateway_interface='br-lan'
	 set wifidogx.@wifidog[0].auth_server_path='/wifidog/'
	 set wifidogx.@wifidog[0].check_interval='60'
	 set wifidogx.@wifidog[0].client_timeout='5'
#有线通过
	 set wifidogx.@wifidog[0].wired_passed='1'
	 set wifidogx.@wifidog[0].auth_server_hostname='192.168.200.1'
	 set wifidogx.@wifidog[0].auth_server_port='80'
#是否禁用
	 set wifidogx.@wifidog[0].disabled='1'
#线程池模式
	 set wifidogx.@wifidog[0].pool_mode='1'
#线程号
	 set wifidogx.@wifidog[0].thread_number='5'
#队列大小
	 set wifidogx.@wifidog[0].queue_size='20'
	 set wifidogx.@wifidog[0].enable='1'
	 commit wifidogx
EOF

echo  "${tag}" "【${tit}】$((h4=h4+1))：" "更新wifidogx配置文件,默认禁用disabled" >> $log

exit 0
