#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="FRP"
if [ -d /mnt/sda1 ]; then
	export log="/mnt/sda1/112.txt"
else
	export log="/tmp/112.txt"
fi

[ -x "/etc/init.d/frp" ] || {
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "错误未安装FRP" >> $log
	exit 0
}
[ -f "/etc/config/frp" ] || touch /etc/config/frp

uci -q batch <<-EOF >/dev/null
	set frp.common=frp
	set fset rp.common.log_max_days='1'
	set frp.common.login_fail_exit='0'
	set frp.common.enable_cpool='0'
	set frp.common.time='40'
	set frp.common.tcp_mux='1'
	set frp.common.vhost_http_port='80'
	set frp.common.vhost_https_port='443'
	set frp.common.server_port='7000'
	set frp.common.log_level='info'
	set frp.common.enable_http_proxy='0'
	set frp.common.protocol='tcp'
	set frp.common.server_addr='frp1.chuantou.org'
	set frp.common.token='www.xxorg.com'
	set frp.common.enabled='1'
	delete frp.@proxy[0]
	add frp proxy
	set frp.@proxy[0]=proxy
	set frp.@proxy[0].type='http'
	set frp.@proxy[0].domain_type='subdomain'
	set frp.@proxy[0].subdomain='wzslrb'
	set frp.@proxy[0].local_ip='127.0.0.1'
	set frp.@proxy[0].local_port='80'
	set frp.@proxy[0].proxy_protocol_version='disable'
	set frp.@proxy[0].use_compression='1'
	set frp.@proxy[0].remark='小房b70'
	set frp.@proxy[0].enable='1'
	commit frp
EOF
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重设frp" >> $log
exit 0