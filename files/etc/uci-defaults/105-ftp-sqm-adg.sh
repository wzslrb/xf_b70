#!/bin/sh

[ -x "/etc/init.d/vsftpd" ] && {
echo "重设vsftpd" >> /mnt/sda1/112.txt
uci set vsftpd.listen.pasv_min_port='50000'
uci set vsftpd.listen.pasv_max_port='51000'
uci commit vsftpd
service vsftpd restart 2 >> /mnt/sda1/112.txt
}

[ -f "/etc/config/sqm" ] && {
echo "重设sqm" >> /mnt/sda1/112.txt
uci set sqm.@queue[0].interface='br-lan'
uci set sqm.@queue[0].download='22000'
uci set sqm.@queue[0].upload='22000'
uci set sqm.@queue[0].linklayer='ethernet'
uci set sqm.@queue[0].overhead='46'
uci set sqm.@queue[0].qdisc='cake'
uci set sqm.@queue[0].script='piece_of_cake.qos'
uci set sqm.@queue[0].enabled='1'
uci commit sqm
service sqm restart
}
[ -f "/etc/config/AdGuardHome" ] && {
echo "重设AdGuardHome" >> /mnt/sda1/112.txt
uci set AdGuardHome.@AdGuardHome[0].old_port='8400'
uci set AdGuardHome.@AdGuardHome[0].httpport='3600'
uci set AdGuardHome.@AdGuardHome[0].enabled='1'
uci set AdGuardHome.@AdGuardHome[0].waitonboot='1'
uci set AdGuardHome.@AdGuardHome[0].redirect='redirect'
uci set AdGuardHome.@AdGuardHome[0].configpath='/etc/config/AdG112.yaml'
uci commit AdGuardHome
service AdGuardHome stop
}

[ -s "/usr/share/AdGuardHome/links.txt" ] && {
echo 更新AdGuard Home升级路径 >> /mnt/sda1/112.txt
sed -i '/\.tar\.gz/s/\.tar/_softfloat\.tar/' /usr/share/AdGuardHome/links.txt
}
