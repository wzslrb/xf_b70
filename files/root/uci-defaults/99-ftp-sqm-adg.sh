#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="FtpSamAdg"


[ -x "/etc/init.d/vsftpd" ] && {
cp -f /mnt/sda1/opt/etc/vsftpd/vsftpd.conf /etc/vsftpd.conf
mkdir -p /etc/vsftpd/
cp -f /mnt/sda1/opt/etc/vsftpd/*.pem /etc/vsftpd/
/etc/init.d/vsftpd enable
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重设vsftpd-tls"
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
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重设sqm"
}

[ -d /mnt/sda1/opt/share/AdGuardHome ] && {
	[ -d /usr/bin/AdGuardHome ] && rm -rf /usr/bin/AdGuardHome
	ln -nsf /mnt/sda1/opt/share/AdGuardHome /usr/bin/AdGuardHome
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重设AdGuardHome目录链接"
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
	set AdGuardHome.AdGuardHome.workdir='/usr/bin/AdGuardHome'
	set AdGuardHome.AdGuardHome.binpath='/usr/bin/AdGuardHome/AdGuardHome'
	set AdGuardHome.AdGuardHome.verbose='0'
	set AdGuardHome.AdGuardHome.crontab='autoupdate cutquerylog cutruntimelog'
	#set AdGuardHome.binmtime=1613384750
	#set AdGuardHome.version=v0.105.0
	commit AdGuardHome
	#cachesize='0' 不缓冲
	set dhcp.@dnsmasq[0].cachesize='0'
	commit dhcp
EOF
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重设AdGuardHome"
}
# run: /usr/bin/AdGuardHome/AdGuardHome -c /usr/bin/AdGuardHome/AdG112.yaml -w /usr/bin/AdGuardHome -p 3600 -l /usr/bin/AdGuardHome/AdGuardHome.log

[ -s "/usr/share/AdGuardHome/links.txt" ] && {
sed -i '/\.tar\.gz/s/\.tar/_softfloat\.tar/' /usr/share/AdGuardHome/links.txt
grep -q 'AdGuardHome' /etc/crontabs/root || {
echo '10 6 * * * /usr/share/AdGuardHome/update_core.sh 2>&1' >> /etc/crontabs/root
echo '0 * * * * /usr/share/AdGuardHome/tailto.sh 2000 /usr/bin/AdGuardHome/data/querylog.json' >> /etc/crontabs/root
echo '15 6 * * * /usr/share/AdGuardHome/tailto.sh 2000 /usr/bin/AdGuardHome/AdGuardHome.log' >> /etc/crontabs/root
}

echo  "${tag}" "【${tit}】$((h4=h4+1))：" "更新AdGuard Home升级路径及计划任务"
}

rm -f /usr/bin/AdGuardHome/AdGuardHome.log && {
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "清除AdGuardHome.log"
}

[ -f "/etc/init.d/adbyby" ] && {
uci -q batch <<-EOF >/dev/null
	set adbyby.@adbyby[0]=adbyby
	set adbyby.@adbyby[0].daemon='2'
	set adbyby.@adbyby[0].lan_mode='0'
	set adbyby.@adbyby[0].cron_mode='1'
	set adbyby.@adbyby[0].enable='1'
	set adbyby.@adbyby[0].wan_mode='1'
	set adbyby.@adbyby[0].mem_mode='1'
	set adbyby.@adbyby[0].update_source='1'
	set adbyby.@adbyby[0].block_ios='1'
	set adbyby.@adbyby[0].block_cnshort='1'
	add_list adbyby.@adbyby[0].subscribe_url='https://easylist-downloads.adblockplus.org/easylistchina.txt'
	add_list adbyby.@adbyby[0].subscribe_url='https://easylist-downloads.adblockplus.org/easylist.txt'
	add_list adbyby.@adbyby[0].subscribe_url='https://easylist-downloads.adblockplus.org/easyprivacy.txt'
	add_list adbyby.@adbyby[0].subscribe_url='https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt'
	add_list adbyby.@adbyby[0].subscribe_url='https://easylist-downloads.adblockplus.org/fanboy-social.txt'
	add_list adbyby.@adbyby[0].subscribe_url='https://www.i-dont-care-about-cookies.eu/abp/'
	add adbyby acl_rule
	set adbyby.@acl_rule[-1].ipaddr='192.168.199.135'
	set adbyby.@acl_rule[-1].filter_mode='global'
	add adbyby acl_rule
	set adbyby.@acl_rule[-1].ipaddr='192.168.199.194'
	set adbyby.@acl_rule[-1].filter_mode='global'
	commit adbyby
EOF
grep -q 'ys168.com' /usr/share/adbyby/adhost.conf || sed -i '$a\ys168.com' /usr/share/adbyby/adhost.conf
grep -q 'adblock.sh' /etc/crontabs/root || echo '12 6 * * * /usr/share/adbyby/adblock.sh > /tmp/adupdate.log 2>&1' >> /etc/crontabs/root
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "广告屏蔽大师 Plus"
}
exit 0