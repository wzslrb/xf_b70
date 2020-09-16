#!/bin/sh
[ -x "/etc/init.d/frp" ] || exit 0
[ -f "/etc/config/frp" ] || touch /etc/config/frp
	echo "重设frp" >> /mnt/sda1/112.txt
	uci set frp.common=frp
	uci set fuci set rp.common.log_max_days='1'
	uci set frp.common.login_fail_exit='0'
	uci set frp.common.enable_cpool='0'
	uci set frp.common.time='40'
	uci set frp.common.tcp_mux='1'
	uci set frp.common.vhost_http_port='80'
	uci set frp.common.vhost_https_port='443'
	uci set frp.common.server_port='7000'
	uci set frp.common.log_level='info'
	uci set frp.common.enable_http_proxy='0'
	uci set frp.common.protocol='tcp'
	uci set frp.common.server_addr='frp1.chuantou.org'
	uci set frp.common.token='www.xxorg.com'
	uci set frp.common.enabled='1'
	uci delete frp.@proxy[0]
	uci add frp proxy
	uci set frp.@proxy[0]=proxy
	uci set frp.@proxy[0].type='http'
	uci set frp.@proxy[0].domain_type='subdomain'
	uci set frp.@proxy[0].subdomain='wzslrb'
	uci set frp.@proxy[0].local_ip='127.0.0.1'
	uci set frp.@proxy[0].local_port='80'
	uci set frp.@proxy[0].proxy_protocol_version='disable'
	uci set frp.@proxy[0].use_compression='1'
	uci set frp.@proxy[0].remark='小房b70'
	uci set frp.@proxy[0].enable='1'
	uci commit frp
#	service frp restart | tee -ai /mnt/sda1/112.txt
