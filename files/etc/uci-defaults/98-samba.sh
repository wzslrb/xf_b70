#!/bin/sh

[ -z "$(opkg list-installed | grep "^samba")" ] && exit 0
[ -f "/etc/config/samba" ] || touch /etc/config/samba
#网络共享（Samba）
#网络共享初始化
sed -i '/^[^#].*invalid users/s/^/#&/g' /etc/samba/smb.conf.template
sed -i '/bind interfaces only/s/only.*/only = off/g' /etc/samba/smb.conf.template
#添加密码root 12
#smbpasswd -a root
echo "root:0:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:7E095E67AE53F77921B9C97FFAADB43F:[U          ]:LCT-00000001:" > /etc/samba/smbpasswd

uci -q batch <<-EOF >/dev/null
	delete samba.@samba[0]
	set samba.def=samba
	set samba.def.name='b'
	set samba.def.workgroup='WORKGROUP'
	set samba.def.description='路由器上的U盘'
	set samba.def.homes='0'
	set samba.def.autoshare='0'
	set samba.def.enabled='1'
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

#service samba restart
