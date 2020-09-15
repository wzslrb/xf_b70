#!/bin/sh

[ -f "/etc/config/samba" ] || exit 0
#网络共享（Samba）
#网络共享初始化
sed -i '/^[^#].*invalid users/s/^/#&/g' /etc/samba/smb.conf.template
sed -i '/bind interfaces only/s/only.*/only = off/g' /etc/samba/smb.conf.template
#添加密码root 12
#smbpasswd -a root
echo "root:0:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:7E095E67AE53F77921B9C97FFAADB43F:[U          ]:LCT-00000001:" > /etc/samba/smbpasswd
uci delete samba.@samba[0]
#uci add samba samba
uci set samba.def=samba
uci set samba.def.name='b'
uci set samba.def.workgroup='WORKGROUP'
uci set samba.def.description='路由器上的U盘'
uci set samba.def.homes='0'
uci set samba.def.autoshare='0'
uci set samba.def.enabled='1'
uci delete samba.@sambashare[0] || echo .
uci delete samba.@sambashare[0] || echo .
uci delete samba.@sambashare[0] || echo .
uci delete samba.@sambashare[0] || echo .
uci set samba.sh1=sambashare
uci set samba.sh1.browseable='yes'
uci set samba.sh1.name='70'
uci set samba.sh1.path='/mnt/sda1'
uci set samba.sh1.users='root'
uci set samba.sh1.read_only='no'
uci set samba.sh1.guest_ok='yes'
uci set samba.sh1.create_mask='0666'
uci set samba.sh1.dir_mask='0777'
uci set samba.sh2=sambashare
uci set samba.sh2.browseable='yes'
uci set samba.sh2.name='电脑资料(只读)'
uci set samba.sh2.path='/mnt/sda1/000000'
uci set samba.sh2.read_only='yes'
uci set samba.sh2.guest_ok='yes'
uci set samba.sh3=sambashare
uci set samba.sh3.browseable='yes'
uci set samba.sh3.name='临时可写目录'
uci set samba.sh3.path='/mnt/sda1/temp'
uci set samba.sh3.read_only='no'
uci set samba.sh3.guest_ok='yes'
uci set samba.sh3.create_mask='0666'
uci set samba.sh3.dir_mask='0777'
uci commit samba
service samba restart
