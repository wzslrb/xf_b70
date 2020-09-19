#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
[ 0 -eq ${#tit} ] && export tit="【$(echo $0)】"

grep -q "\/init\.sh" /etc/rc.local && {
	sed -i '/^\/root/s/.*//' /etc/rc.local
	sed -i '3d' /etc/rc.local
	logger -t "${tit}" "$((h4=h4+1))" "删除开机脚本rc.local"
}

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
	set dhcp.lan.interface='lan'
	set dhcp.lan.start='100'
	set dhcp.lan.limit='150'
	set dhcp.lan.leasetime='12h'
	uci commit dhcp
	/etc/init.d/dnsmasq restart
	logger -t "${tit}" "$((h4=h4+1))" "删除dhcp默认ipv6"
}
fi

if [ -d /www/wifidog ]; then {
	if [[ -n "$(/usr/bin/wdctlx status | grep Error:)" ]]; then {
		uci set wifidogx.@wifidog[0].disabled='0'
		uci commit wifidogx
		logger -t "${tit}" "$((h4=h4+1))" "apfreewifidog未运行，启动中……"
		/etc/init.d/wifidogx restart
	}
	else {
		logger -t "${tit}" "$((h4=h4+1))" "apfreewifidog运行中，将停止……"
		/etc/init.d/wifidogx stop
	}
	fi
}
else
	logger -t "${tit}" "$((h4=h4+1))" "错误：/www/wifidog不存在……"
fi

[ -z "$(opkg list-installed | grep '^samba')" ] && {
	logger -t "${tit}" "$((h4=h4+1))" "错误，未安装samba exit 0"
	exit 0
}

sed -i '/^[^#].*invalid users/s/^/#&/g' /etc/samba/smb.conf.template
sed -i '/bind interfaces only/s/only.*/only = off/g' /etc/samba/smb.conf.template
echo "root:0:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:7E095E67AE53F77921B9C97FFAADB43F:[U          ]:LCT-00000001:" > /etc/samba/smbpasswd
logger -t "${tit}" "$((h4=h4+1))" "修改smb.conf.template及添加密码"

if [ -f /etc/config/samba ]; then {
uci -q batch <<-EOF >/dev/null
	delete samba.@samba[1]
	delete samba.@samba[0]
	set samba.def=samba
	set samba.def.name='b'
	set samba.def.workgroup='WORKGROUP'
	set samba.def.description='路由器上的U盘'
	set samba.def.homes='0'
	set samba.def.autoshare='0'
	set samba.def.enabled='1'
	delete samba.@sambashare[4]
	delete samba.@sambashare[3]
	delete samba.@sambashare[2]
	delete samba.@sambashare[1]
	delete samba.@sambashare[0]
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
	logger -t "${tit}" "$((h4=h4+1))" "添加diy共享samba配置"
	service samba restart
}
else
{
	logger -t "${tit}" "$((h4=h4+1))" "没有发现samba配置文件"
}
fi

exit 0

