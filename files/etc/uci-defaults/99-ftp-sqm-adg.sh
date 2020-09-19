#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0

[ -x "/etc/init.d/vsftpd" ] && {
uci set vsftpd.listen.pasv_min_port='50000'
uci set vsftpd.listen.pasv_max_port='51000'
uci commit vsftpd
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-重设vsftpd" >> /mnt/sda1/112.txt
}

[ -f "/etc/config/sqm" ] && {
uci set sqm.@queue[0].interface='br-lan'
uci set sqm.@queue[0].download='22000'
uci set sqm.@queue[0].upload='22000'
uci set sqm.@queue[0].linklayer='ethernet'
uci set sqm.@queue[0].overhead='46'
uci set sqm.@queue[0].qdisc='cake'
uci set sqm.@queue[0].script='piece_of_cake.qos'
uci set sqm.@queue[0].enabled='1'
uci commit sqm
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-重设sqm" >> /mnt/sda1/112.txt
}

[ -d /mnt/sda1/lost\+found/AdGuardHome ] && {
	[ -d /usr/bin/AdGuardHome ] && rm -rf /usr/bin/AdGuardHome
	ln -nsf /mnt/sda1/lost\+found/AdGuardHome /usr/bin/AdGuardHome
	echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-重设AdGuardHome目录链接" >> /mnt/sda1/112.txt
}

[ -f "/etc/config/AdGuardHome" ] && {
uci -q batch <<-EOF >/dev/null
	set AdGuardHome.@AdGuardHome[0].old_port='8400'
	set AdGuardHome.@AdGuardHome[0].httpport='3600'
	set AdGuardHome.@AdGuardHome[0].enabled='1'
	set AdGuardHome.@AdGuardHome[0].waitonboot='1'
	set AdGuardHome.@AdGuardHome[0].redirect='redirect'
	set AdGuardHome.@AdGuardHome[0].configpath='/usr/bin/AdGuardHome/AdG112.yaml'
	set AdGuardHome.AdGuardHome.logfile='/usr/bin/AdGuardHome/AdGuardHome.log'
	set AdGuardHome.AdGuardHome.verbose='0'
	commit AdGuardHome
EOF
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-重设AdGuardHome" >> /mnt/sda1/112.txt
}

[ -s "/usr/share/AdGuardHome/links.txt" ] && {
sed -i '/\.tar\.gz/s/\.tar/_softfloat\.tar/' /usr/share/AdGuardHome/links.txt
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-更新AdGuard Home升级路径" >> /mnt/sda1/112.txt
}
[ -s "/usr/bin/AdGuardHome/AdGuardHome.log" ] && {
rm -f /usr/bin/AdGuardHome/AdGuardHome.log
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-清除AdGuardHome.log" >> /mnt/sda1/112.txt
}

exit 0