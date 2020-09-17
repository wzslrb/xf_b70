#!/bin/sh

[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt

uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
uci set system.@system[0].hostname='B70'
uci commit system

logger -t "【初始化】" "修改主题、hostname"
#重建ssh链接
cd /usr/bin
mv ssh dropbear-ssh
mv scp dropbear-scp
ln -s /usr/bin/openssh-ssh ssh
ln -s /usr/bin/openssh-scp scp
logger -t "【初始化】" "更新ssh链接"

#重建apfee目录
[ -d "/mnt/sda1/portal/wifidog" ] && ln -nsf /mnt/sda1/portal/wifidog /www/wifidog
logger -t "【初始化】" "重建apfee目录"

#主机短别名
sed -i 's/.*localhost ip6.*/& h/g' /etc/hosts
#echo -e '192.168.199.1\th' >> /etc/hosts
logger -t "【初始化】" "主机短别名 h"


uci add_list uhttpd.main.listen_https='0.0.0.0:443'
uci add_list uhttpd.main.listen_https='[::]:443'
uci commit uhttpd
logger -t "【初始化】" "添加 https 访问"


rm -f /common || echo .
rm -f /ipq40xx || echo .


[ -f "/etc/crontabs/root" ] && sed -i '1i 35 21 * * * halt' /etc/crontabs/root || echo "35 21 * * * halt" >> /etc/crontabs/root
logger -t "【初始化】" "添加计划任务关机"

sed -i '/^root/s/.*/root:$1$VZ4w9Iwy$J0\/V2CNV1HoKG9DAHlPrn1:18506:0:99999:7:::/' /etc/shadow
logger -t "【初始化】" "修改root密码"

[ -f "/etc/config/aria2" ] && {
	uci delete aria2.main.bt_tracker
	uci set aria2.main.enable_log='false'
	uci set aria2.main.enabled='1'
	uci set aria2.main.rpc_auth_method='none'
	uci commit aria2
	logger -t "【初始化】" "设置默认启动启动aria2"
}

#修改证书权限
chmod 0400 /etc/dropbear/id_rsa
logger -t "【初始化】" "修改证书权限"
exit 0
