#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="FRP"
if [ -x "/etc/init.d/zerotier" ]; then
	sed -i '/option enabled/s/0/1/' /etc/config/zerotier
	sed -i "\$a\\        option nat '1'" /etc/config/zerotier
	sed -i '/\slist/s/\w\{16\}/8850338390291d00/g' /etc/config/zerotier
	sed -i '/option secret/s/\S*$/'"'9b4d1ee446:0:0a1e9d6cbc0fc0511191e8fc5b451f63ba3ba150ef31637a52500fc92ae8ca1f7cde39ad8e1dfab9758303f753975e9a32f129d8edf72722bbcf214f1c65be7a:66697dc740eb7f45b56940c1d48ed4a2a338cba35deeda4127488c7da2a6e7955bea427729b72c5e5eae1090d0f962b49fb2b79ea5ece510ceedc5560d9f3309'/" /etc/config/zerotier
	# 替换脚本 firewall.zerotier.path='/etc/zerotier.start'
	[ -d /mnt/sda1/portal/ssh/zero ] && {
		[ -d /etc/config/zero ] && rm -rf /etc/config/zero
		ln -s /mnt/sda1/portal/ssh/zero /etc/config/zero
		cp -f /mnt/sda1/portal/ssh/zerotier.sh /etc/zerotier.start
		chmod +x /etc/zerotier.start
	}
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "zerotier初始化"
fi

if [ -x "/etc/init.d/frp" ]; then
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
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "重设frp"
else
	echo  "${tag}" "【${tit}】$((h4=h4+1))：" "错误未安装FRP"
fi
exit 0