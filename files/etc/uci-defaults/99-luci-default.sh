#!/bin/sh

[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt
echo "init脚本" >> /mnt/sda1/112.txt
uci set luci.main.lang=zh_cn
uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
uci set system.@system[0].hostname='B70'
uci commit system
#重建ssh链接
cd /usr/bin
mv ssh dropbear-ssh
mv scp dropbear-scp
ln -s /usr/bin/openssh-ssh ssh
ln -s /usr/bin/openssh-scp scp
#重建apfee目录
[ -d "/mnt/sda1/portal/wifidog" ] && ln -nsf /mnt/sda1/portal/wifidog /www/wifidog

#主机短别名
#sed -i 's/.*localhost ip6.*/& h/g' /etc/hosts
#echo -e '192.168.199.1\th' >> /etc/hosts
echo "主机短别名" >> /mnt/sda1/112.txt
#cat /etc/hosts >> /mnt/sda1/112.txt

echo uhttpd 添加 https 访问 >> /mnt/sda1/112.txt
uci add_list uhttpd.main.listen_https='0.0.0.0:443'
uci add_list uhttpd.main.listen_https='[::]:443'
uci commit uhttpd
service uhttpd restart 2 >> /mnt/sda1/112.txt
rm -f /common || echo .
rm -f /ipq40xx || echo .
echo 添加计划任务关机 >> /mnt/sda1/112.txt
[ -f "/etc/crontabs/root" ] && sed -i '1i 35 21 * * * halt' /etc/crontabs/root || echo "35 21 * * * halt" >> /etc/crontabs/root
echo 修改root密码 >> /mnt/sda1/112.txt
sed -i '/^root/s/.*/root:$1$VZ4w9Iwy$J0\/V2CNV1HoKG9DAHlPrn1:18506:0:99999:7:::/' /etc/shadow
echo 启动aria2 >> /mnt/sda1/112.txt
service aria2 enable
service aria2 restart
#修改证书权限
chmod 0400 /etc/dropbear/id_rsa

exit 0
