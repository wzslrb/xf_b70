#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="杂项"



#[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt

# 流量统计nlbwmon
# uci set nlbwmon.@nlbwmon[0].commit_interval='128s'
# uci set nlbwmon.@nlbwmon[0].database_directory='/mnt/sda1/portal/nlbwmon'
# uci set nlbwmon.@nlbwmon[0].database_generations='840'
# uci commit nlbwmon

uci set system.@system[0].log_size='840'
uci set system.@system[0].hostname='B70'
uci delete system.ntp.enable_server
uci commit system

# echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改主题、hostname"
#重建ssh链接

[ -e /usr/bin/openssh-ssh ] && {
cd /usr/bin
mv ssh dropbear-ssh
mv scp dropbear-scp
ln -s /usr/bin/openssh-ssh ssh
ln -s /usr/bin/openssh-scp scp
sed -i "/StrictHostKeyChecking/s/^#[[:space:]]*//" /etc/ssh/ssh_config
sed -i "/StrictHostKeyChecking/s/ask/no/" /etc/ssh/ssh_config
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "更新ssh链接,登录免提示……"
}


#主机短别名
sed -i 's/.*localhost ip6.*/& h/g' /etc/hosts
#echo -e '192.168.199.1\th' >> /etc/hosts
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "主机短别名 h"

[ -z "$(uci -q get uhttpd.main.listen_https)" ] && {
uci add_list uhttpd.main.listen_https='0.0.0.0:443'
uci add_list uhttpd.main.listen_https='[::]:443'
uci commit uhttpd
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "添加 https 访问"
}

[ -e /common ] && rm -f /common
[ -e /ipq40xx ] && rm -f /ipq40xx

[ -f /etc/shadow ] && {
sed -i '/^root/s/.*/root:$1$VZ4w9Iwy$J0\/V2CNV1HoKG9DAHlPrn1:18506:0:99999:7:::/' /etc/shadow
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改root密码"
}
[ -f "/etc/config/aria2" ] && {
	uci delete aria2.main.bt_tracker
	uci set aria2.main.enable_log='false'
	uci set aria2.main.enabled='1'
	uci set aria2.main.rpc_auth_method='token'
	uci set aria2.main.rpc_secret='7907298'

	uci commit aria2
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "设置默认启动启动aria2"
#	ln -nsf /mnt/sda1/portal/wifidog /www/wifidog		'none'
}

[ -d "/mnt/sda1/opt/var/opkg-list" ] && {
	sed -i '/^lists_dir/s/.*/lists_dir ext \/opt\/var\/opkg-list/' /etc/opkg.conf
	echo 'dest usb /mnt/sda1/bin' >> /etc/opkg.conf
	# echo 'option check_signature 0' >> /etc/opkg.conf
	# echo 'arch all 100' >> /etc/opkg.conf
	# echo 'arch mipsel-3x 150' >> /etc/opkg.conf					# ramips 200
	# echo 'arch mipsel-3.4 160' >> /etc/opkg.conf				# ramips_24kec 300
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改opkg.conf"
}

[ -s /rom/etc/opkg/distfeeds.conf ] && {
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "添加自定义/etc/opkg/distfeeds.conf"
grep "^src" /rom/etc/opkg/distfeeds.conf | sed 's/^/# &/' >> /etc/opkg/customfeeds.conf
}

# sed -i /dhcp\.lan\./d /etc/uci-defaults/odhcpd.defaults
rm -f /etc/uci-defaults/odhcpd.defaults
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改/etc/uci-defaults/odhcpd.defaults"


debuglog=/mnt/sda1/portal/ssh/99-hotplug.sh
[ -f ${debuglog} ] && {
	for hnp in $(ls -d /etc/hotplug.d/*);do
	cp -f ${debuglog} ${hnp}/
	done
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "记录hotplug.d事件日志"
}

[ -x /mnt/sda1/opt/onmp/in.sh ] && {
	#  sh /mnt/sda1/opt/onmp/in.sh >/dev/null 2>&1
	ln -sf "/mnt/sda1/opt" /opt
	cp -f /opt/onmp/entware_start.sh /etc/init.d/entware
	echo ". /opt/etc/profile" >> /etc/profile
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "安装entware环境"
}

which php-cgi && {
	uci add_list uhttpd.main.interpreter=".php=`which php-cgi`"
	uci add_list uhttpd.main.index_page="index.php"
	uci commit uhttpd
}
[ -x /opt/bin/zsh ] && {
	echo '/opt/bin/zsh' >> /etc/shells
	ln -s /opt/root/.zsh* /root/
	#zsh安装 for ss in /opt/root/.zprezto/runcoms/^R*;do echo ln -sf ${ss} ~/.${ss:t}; done 替换 $(basename $0) ${0##*/}
	#find /opt/root/.zprezto/runcoms/ ! -name RE* -type f -exec bash -c 'ln -sf $0 ~/.${0##*/}' "{}" \;
	ln -sf /opt/share/zprezto/runcoms/zshrc ~/.zshrc
}
[ -x /opt/bin/bash ] && {
	echo '/opt/bin/bash' >> /etc/shells
	ln -s /opt/root/.bash* /root/
}
[ -x /bin/bash ] && {
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "设置默认shell bash"
	chsh -s /bin/bash || sed -i '/^root/s/[^:]*$/\/bin\/bash/' /etc/passwd
}

#修改证书权限
uci delete dropbear.@dropbear[0].Interface
uci set dropbear.@dropbear[0].PasswordAuth='on'
uci commit dropbear
[ -d "/opt/root/.ssh" ] && {
	ln -sf /opt/root/.ssh ~/.ssh
	cat ~/.ssh/id_rsa.pub >> /etc/dropbear/authorized_keys
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "修改SSH 私匙登录"
}


dump222(){			#定义函数多行注释
if [ -s /mnt/sda1/lost\+found/init.sh ]; then {
	chmod +x /mnt/sda1/lost+found/init.sh
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "发现U盘init.sh，执行……"
	/bin/bash /mnt/sda1/lost+found/init.sh
}
else
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "没有发现U盘init.sh，……"
fi
}
exit 0