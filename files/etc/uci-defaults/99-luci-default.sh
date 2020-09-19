#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0

#[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt

uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
uci set system.@system[0].hostname='B70'
uci commit system

echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-修改主题、hostname" >> /mnt/sda1/112.txt
#重建ssh链接
cd /usr/bin
mv ssh dropbear-ssh
mv scp dropbear-scp
ln -s /usr/bin/openssh-ssh ssh
ln -s /usr/bin/openssh-scp scp
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-更新ssh链接" >> /mnt/sda1/112.txt


#主机短别名
sed -i 's/.*localhost ip6.*/& h/g' /etc/hosts
#echo -e '192.168.199.1\th' >> /etc/hosts
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-主机短别名 h" >> /mnt/sda1/112.txt

[ -z "$(uci get uhttpd.main.listen_https 2>/dev/null)" ] && {
uci add_list uhttpd.main.listen_https='0.0.0.0:443'
uci add_list uhttpd.main.listen_https='[::]:443'
uci commit uhttpd
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-添加 https 访问" >> /mnt/sda1/112.txt
}

[ -e /common ] && rm -f /common
[ -e /ipq40xx ] && rm -f /ipq40xx

[ -f /etc/crontabs/root ] && {
sed -i '1i 35 21 * * * halt' /etc/crontabs/root || echo "35 21 * * * halt" >> /etc/crontabs/root
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-添加计划任务关机" >> /mnt/sda1/112.txt
}
[ -f /etc/shadow ] && {
sed -i '/^root/s/.*/root:$1$VZ4w9Iwy$J0\/V2CNV1HoKG9DAHlPrn1:18506:0:99999:7:::/' /etc/shadow
echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-修改root密码" >> /mnt/sda1/112.txt
}
[ -f "/etc/config/aria2" ] && {
	uci delete aria2.main.bt_tracker
	uci set aria2.main.enable_log='false'
	uci set aria2.main.enabled='1'
	uci set aria2.main.rpc_auth_method='none'
	uci commit aria2
	echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-设置默认启动启动aria2" >> /mnt/sda1/112.txt
}

#修改证书权限
[ -s /etc/dropbear/id_rsa ] && {
	chmod 0400 /etc/dropbear/id_rsa
	echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-修改证书权限" >> /mnt/sda1/112.txt
}

if [[ -f /etc/rc.local && -z $(grep "wifi\.sh" /etc/rc.local) ]];then {
	if [ -x /mnt/sda1/temp/wifi.sh ]; then {
	sed -i '/^exit 0/i /mnt/sda1/temp/wifi.sh' /etc/rc.local
	echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-插入开机脚本rc.local" >> /mnt/sda1/112.txt
	}
	else
	echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-没有可用的开机脚本rc.local" >> /mnt/sda1/112.txt
	fi
}
else {
	sed -i '/^\/mnt/s/.*//' /etc/rc.local
	sed -i '3d' /etc/rc.local
	echo "【$(echo $0 | sed 's/.*\///')】$((h4=h4+1))-没有或删除开机脚本rc.local" >> /mnt/sda1/112.txt
}
fi

exit 0
