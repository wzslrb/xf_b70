#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="FRP"
if [ -x "/etc/init.d/zerotier" ]; then
	uci set zerotier.sample_config.enabled='1'
	uci delete zerotier.sample_config.join
	uci add_list zerotier.sample_config.join='8850338390291d00'
	uci set zerotier.sample_config.nat='1'
	uci set zerotier.sample_config.secret='9b4d1ee446:0:0a1e9d6cbc0fc0511191e8fc5b451f63ba3ba150ef31637a52500fc92ae8ca1f7cde39ad8e1dfab9758303f753975e9a32f129d8edf72722bbcf214f1c65be7a:66697dc740eb7f45b56940c1d48ed4a2a338cba35deeda4127488c7da2a6e7955bea427729b72c5e5eae1090d0f962b49fb2b79ea5ece510ceedc5560d9f3309'
	uci set network.zerotier=interface
	uci set network.zerotier.proto='static'
	uci set network.zerotier.ifname='ztbpabvhuq'
	uci set network.zerotier.ipaddr='172.2.2.2'
	uci set network.zerotier.netmask='255.255.255.0'
	uci set firewall.zerotier=include
	uci set firewall.zerotier.type='script'
	uci set firewall.zerotier.path='/etc/zerotier.start'
	uci set firewall.zerotier.reload='1'
	uci set firewall.zerotier2=zone
	uci set firewall.zerotier2.name='zerotier'
	uci set firewall.zerotier2.input='ACCEPT'
	uci set firewall.zerotier2.forward='ACCEPT'
	uci set firewall.zerotier2.output='ACCEPT'
	uci set firewall.zerotier2.network='zerotier'
	uci commit
	sed -i '$a\iptables -I FORWARD -i ztbpabvhuq -j ACCEPT' /etc/firewall.user
	sed -i '$a\iptables -I FORWARD -o ztbpabvhuq -j ACCEPT' /etc/firewall.user
	sed -i '$a\iptables -t nat -I POSTROUTING -o ztbpabvhuq -j MASQUERADE' /etc/firewall.user
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