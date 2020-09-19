#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tit="无线共享"

[ ! -f /etc/config/wireless ] && {
	echo "【${tit}】$((h4=h4+1))-wifi config初始化无线配置文件" >> /mnt/sda1/112.txt
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
echo "【${tit}】$((h4=h4+1))-diy无线配置文件" >> /mnt/sda1/112.txt
}
else
{
	echo "【${tit}】$((h4=h4+1))-★★★★★没有配置文件" >> /mnt/sda1/112.txt
	[ -f /mnt/sda1/lost\+found/wireless ] && {
		cp -pf /mnt/sda1/lost\+found/wireless /etc/config/
		echo "【${tit}】$((h4=h4+1))-恢复备份的wireless" >> /mnt/sda1/112.txt
	}
}
fi

#wifi down && wifi up

[ -z "$(opkg list-installed | grep '^samba')" ] && {
	echo "【${tit}】$((h4=h4+1))-错误，未安装samba" >> /mnt/sda1/112.txt
	exit 0
}



sed -i '/^[^#].*invalid users/s/^/#&/g' /etc/samba/smb.conf.template
sed -i '/bind interfaces only/s/only.*/only = off/g' /etc/samba/smb.conf.template
echo "root:0:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:7E095E67AE53F77921B9C97FFAADB43F:[U          ]:LCT-00000001:" > /etc/samba/smbpasswd
echo "【${tit}】$((h4=h4+1))-修改smb.conf.template及添加密码" >> /mnt/sda1/112.txt

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
	echo "【${tit}】$((h4=h4+1))-添加diy共享配置" >> /mnt/sda1/112.txt
}
else
{
	echo "【${tit}】$((h4=h4+1))-没有发现配置文件" >> /mnt/sda1/112.txt
}
fi

exit 0
