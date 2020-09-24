#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="杂项"
[ -d /mnt/sda1 ] && export log="/mnt/sda1/112.txt" || export log="/tmp/112.txt"


#[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt

uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci

uci set system.@system[0].log_size='840'
[ -d /mnt/sda1/portal ] && {
	rm -f /mnt/sda1/portal/system.log
	touch /mnt/sda1/portal/system.log
	uci set system.@system[0].log_file='/mnt/sda1/portal/system.log'
}
uci set system.@system[0].hostname='B70'
uci delete system.ntp.enable_server
uci commit system

echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改主题、hostname" >> $log
#重建ssh链接

[ -e /usr/bin/openssh-ssh ] && {
cd /usr/bin
mv ssh dropbear-ssh
mv scp dropbear-scp
ln -s /usr/bin/openssh-ssh ssh
ln -s /usr/bin/openssh-scp scp
sed -i "/StrictHostKeyChecking/s/^#[[:space:]]*//" /etc/ssh/ssh_config
sed -i "/StrictHostKeyChecking/s/ask/no/" /etc/ssh/ssh_config
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "更新ssh链接,登录免提示……" >> $log
}


#主机短别名
sed -i 's/.*localhost ip6.*/& h/g' /etc/hosts
#echo -e '192.168.199.1\th' >> /etc/hosts
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "主机短别名 h" >> $log

[ -z "$(uci get uhttpd.main.listen_https 2>/dev/null)" ] && {
uci add_list uhttpd.main.listen_https='0.0.0.0:443'
uci add_list uhttpd.main.listen_https='[::]:443'
uci commit uhttpd
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "添加 https 访问" >> $log
}

[ -e /common ] && rm -f /common
[ -e /ipq40xx ] && rm -f /ipq40xx

[ -f /etc/shadow ] && {
sed -i '/^root/s/.*/root:$1$VZ4w9Iwy$J0\/V2CNV1HoKG9DAHlPrn1:18506:0:99999:7:::/' /etc/shadow
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改root密码" >> $log
}
[ -f "/etc/config/aria2" ] && {
	uci delete aria2.main.bt_tracker
	uci set aria2.main.enable_log='false'
	uci set aria2.main.enabled='1'
	uci set aria2.main.rpc_auth_method='none'
	uci commit aria2
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "设置默认启动启动aria2" >> $log
}

#修改证书权限
[ -s /etc/dropbear/id_rsa ] && {
	chmod 0400 /etc/dropbear/id_rsa
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改证书权限" >> $log
}

[ -s /rom/etc/opkg/distfeeds.conf ] && {
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "备份到原始/etc/opkg/distfeeds.conf" >> $log
grep "^src" /rom/etc/opkg/distfeeds.conf | sed 's/^/# &/' >> /etc/opkg/customfeeds.conf
}

sed -i /dhcp\.lan\./d /etc/uci-defaults/odhcpd.defaults
cp /etc/uci-defaults/odhcpd.defaults /mnt/sda1/temp 
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "备份/etc/uci-defaults/odhcpd.defaults /mnt/sda1/temp" >> $log

dump222(){			#定义函数多行注释
if [ -s /mnt/sda1/lost\+found/init.sh ]; then {
	chmod +x /mnt/sda1/lost+found/init.sh
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "发现U盘init.sh，执行……" >> $log
	/bin/bash /mnt/sda1/lost+found/init.sh
}
else
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "没有发现U盘init.sh，……" >> $log
fi
}
exit 0
