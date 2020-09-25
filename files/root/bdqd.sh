#!/bin/sh

unset wz hjbc nz
[ 0 -eq ${#h4} ] && export h4=0
[ 0 -eq ${#tag} ] && export tag="【$(echo $0)】"
[ ! 0 -eq ${#log} ] || [ -d /mnt/sda1 ] && export log="/mnt/sda1/112.txt" || export log="/tmp/112.txt"
[ 0 -eq ${#gg} ] && export gg=/tmp/bu_ji_xu	#跳过环境变量 创建touch $gg
export wz=/mnt/sda1/portal/bdqd_wz.sh		#外置存储开机脚本 unset
export hjbc=/mnt/sda1/portal/bdqd_bc.sh		#内置补充脚本
export bdqd=$(echo $0 | sed 's/\//\\\//g')	#本地启动脚本

[ -s $log ] && {
	logger -t "${tag}" "★载入初始化日志★:" "$log"
	while read line; do logger $line; done < $log
	rm -f $log
}

grep -q "$0" /etc/rc.local && {
	#	sed -i "/^exit 0/i $bdqd" /etc/rc.local
	sed -i "/$bdqd/d" /etc/rc.local || sed -i "/$(basename $0)/d" /etc/rc.local
	logger -t "${tag}" "$((h4=h4+1))" "删除/etc/rc.local本地启动脚本$0"
}

if [ -s $wz ]; then {
	logger -t "${tag}" "$((h4=h4+1))" "发现外置存储开机脚本$wz，载入……"
	chmod +x $wz
	/bin/bash $wz
}
else
	logger -t "${tag}" "$((h4=h4+1))" "未发现外置存储开机脚本$wz"
fi

[ -e $gg ] && {
	logger -t "$tag" "发现跳过标志，不再执行内置脚本，程序退出……"
	rm -rf $gg
	exit 0
}

sed -i '1i 35 21 * * * halt' /etc/crontabs/root || echo "35 21 * * * halt" >> /etc/crontabs/root
logger -t "${tag}" "$((h4=h4+1))" "添加计划任务关机"

if [ "$(uci get dhcp.lan.ra 2>&1)" = "server" ]; then {
	uci delete dhcp.@dnsmasq[0].boguspriv
	uci delete dhcp.@dnsmasq[0].filterwin2k
	uci delete dhcp.@dnsmasq[0].nonegcache
	uci delete dhcp.lan.dhcpv6
	uci delete dhcp.lan.ra
	uci delete dhcp.lan.ra_slaac
	uci del_list dhcp.lan.ra_flags='managed-config'
	uci del_list dhcp.lan.ra_flags='other-config'
	uci set dhcp.lan.ignore='0'
	uci delete dhcp.lan.ignore
	uci commit dhcp
	/etc/init.d/dnsmasq restart
	logger -t "${tag}" "$((h4=h4+1))" "删除dhcp默认ipv6"
}
fi

if [ -d /www/wifidog ]; then {
	if [[ -n "$(/usr/bin/wdctlx status | grep Error:)" ]]; then {
		uci set wifidogx.@wifidog[0].disabled='0'
		uci commit wifidogx
		logger -t "${tag}" "$((h4=h4+1))" "apfreewifidog未运行，启动中……"
		/etc/init.d/wifidogx restart
	}
	else {
		logger -t "${tag}" "$((h4=h4+1))" "apfreewifidog运行中，将停止……"
		/etc/init.d/wifidogx stop
	}
	fi
}
else
	logger -t "${tag}" "$((h4=h4+1))" "错误：/www/wifidog不存在……"
fi

if [ -z "$(opkg list-installed | grep '^samba36')" ]; then
	logger -t "${tag}" "$((h4=h4+1))" "错误，未安装samba36 跳过"
else {
	sed -i '/^[^#].*invalid users/s/^/#&/g' /etc/samba/smb.conf.template
	sed -i '/bind interfaces only/s/only.*/only = off/g' /etc/samba/smb.conf.template
	echo "root:0:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:7E095E67AE53F77921B9C97FFAADB43F:[U          ]:LCT-00000001:" > /etc/samba/smbpasswd
	logger -t "${tag}" "$((h4=h4+1))" "修改smb.conf.template及添加密码"

	if [ -f /etc/config/samba ]; then {
	uci -q batch <<-EOF >/dev/null
		delete samba.@samba[-1]
		delete samba.@samba[-1]
		set samba.def=samba
		set samba.def.name='b'
		set samba.def.workgroup='WORKGROUP'
		set samba.def.description='路由器上的U盘'
		set samba.def.homes='0'
		set samba.def.autoshare='0'
		set samba.def.enabled='1'
		delete samba.@sambashare[-1]
		delete samba.@sambashare[-1]
		delete samba.@sambashare[-1]
		delete samba.@sambashare[-1]
		delete samba.@sambashare[-1]
		set samba.sh1=sambashare
		set samba.sh1.browseable='yes'
		set samba.sh1.name='70'
		set samba.sh1.path='/mnt/sda1'
		set samba.sh1.users='root'
		set samba.sh1.read_only='no'
		set samba.sh1.guest_ok='yes'
		set samba.sh1.create_mask='0666'
		set samba.sh1.dir_mask='0777'
		set samba.sh2=sambashare
		set samba.sh2.browseable='yes'
		set samba.sh2.name='电脑资料(只读)'
		set samba.sh2.path='/mnt/sda1/000000'
		set samba.sh2.read_only='yes'
		set samba.sh2.guest_ok='yes'
		set samba.sh3=sambashare
		set samba.sh3.browseable='yes'
		set samba.sh3.name='临时可写目录'
		set samba.sh3.path='/mnt/sda1/temp'
		set samba.sh3.read_only='no'
		set samba.sh3.guest_ok='yes'
		set samba.sh3.create_mask='0666'
		set samba.sh3.dir_mask='0777'
		commit samba
	EOF
		logger -t "${tag}" "$((h4=h4+1))" "添加diy共享samba配置，稍后36重启samba"
		sleep 36 && service samba restart &
	}
	else
	{
		logger -t "${tag}" "$((h4=h4+1))" "没有发现samba配置文件"
	}
	fi
}
fi

[ -f "/etc/config/AdGuardHome" ] && {
logger -t "${tag}" "$((h4=h4+1))" "稍后36秒重启AdGuardHome"
sleep 36 && service AdGuardHome restart &
}


if [ -s $hjbc ]; then {
	logger -t "${tag}" "$((h4=h4+1))" "发现后继补充$hjbc，载入……"
	chmod +x $hjbc
	/bin/bash $hjbc
}
else
	logger -t "${tag}" "$((h4=h4+1))" "未发现后继补充$hjbc，程序退出……"
fi

exit 0

