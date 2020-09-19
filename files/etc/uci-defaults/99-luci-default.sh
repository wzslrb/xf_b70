#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
if [ -d /mnt/sda1 ]; then
	export log="/mnt/sda1/112.txt"
else
	export log="/tmp/112.txt"
fi
export tit="杂项"

#[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt

uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
uci set system.@system[0].hostname='B70'
uci commit system

logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "修改主题、hostname"
#重建ssh链接
cd /usr/bin
mv ssh dropbear-ssh
mv scp dropbear-scp
ln -s /usr/bin/openssh-ssh ssh
ln -s /usr/bin/openssh-scp scp
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "更新ssh链接"


#主机短别名
sed -i 's/.*localhost ip6.*/& h/g' /etc/hosts
#echo -e '192.168.199.1\th' >> /etc/hosts
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "主机短别名 h"

[ -z "$(uci get uhttpd.main.listen_https 2>/dev/null)" ] && {
uci add_list uhttpd.main.listen_https='0.0.0.0:443'
uci add_list uhttpd.main.listen_https='[::]:443'
uci commit uhttpd
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "添加 https 访问"
}

[ -e /common ] && rm -f /common
[ -e /ipq40xx ] && rm -f /ipq40xx

[ -f /etc/crontabs/root ] && {
sed -i '1i 35 21 * * * halt' /etc/crontabs/root || echo "35 21 * * * halt" >> /etc/crontabs/root
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "添加计划任务关机"
}
[ -f /etc/shadow ] && {
sed -i '/^root/s/.*/root:$1$VZ4w9Iwy$J0\/V2CNV1HoKG9DAHlPrn1:18506:0:99999:7:::/' /etc/shadow
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "修改root密码"
}
[ -f "/etc/config/aria2" ] && {
	uci delete aria2.main.bt_tracker
	uci set aria2.main.enable_log='false'
	uci set aria2.main.enabled='1'
	uci set aria2.main.rpc_auth_method='none'
	uci commit aria2
	logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "设置默认启动启动aria2"
}

#修改证书权限
[ -s /etc/dropbear/id_rsa ] && {
	chmod 0400 /etc/dropbear/id_rsa
	logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "修改证书权限"
}

[ -s /mnt/sda1/lost\+found/init.sh ] && {
	cp -pf /mnt/sda1/lost+found/init.sh /root/init.sh
	logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "发现U盘init.sh，替换/root/init.sh"
}

[ -s /root/init.sh ] && {
chmod +x /root/init.sh
sed -i '/^exit 0/i /root/init.sh' /etc/rc.local
logger -t "${tag}" "【${tit}】$((h4=h4+1))：" "添加启动脚本/root/init.sh到/etc/rc.local"
}
exit 0
