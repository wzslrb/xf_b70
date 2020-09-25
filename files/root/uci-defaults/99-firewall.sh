#!/bin/sh

[ 0 -eq ${#h4} ] && export h4=0
export tag="$(echo $0 | sed 's/.*\///')"
export tit="防火墙"


[ -s "/etc/firewall.user" ] && {
sed -i '/^[^#]/s/.*/# &/' /etc/firewall.user
#service firewall reload | tee -ai /mnt/sda1/112.txt
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "注释防火墙转发规则iptables 53"
} 

uci -q batch <<-EOF >/dev/null
	set firewall.web=rule
	set firewall.web.target='ACCEPT'
	set firewall.web.src='wan'
	set firewall.web.proto='tcp'
	set firewall.web.dest_port='80 443'
	set firewall.web.name='外网web'

	set firewall.samba_udp=rule
	set firewall.samba_udp.target='ACCEPT'
	set firewall.samba_udp.src='wan'
	set firewall.samba_udp.proto='udp'
	set firewall.samba_udp.dest_port='137-138'
	set firewall.samba_udp.name='网络共享udp'

	set firewall.samba_tcp=rule
	set firewall.samba_tcp.target='ACCEPT'
	set firewall.samba_tcp.src='wan'
	set firewall.samba_tcp.proto='tcp'
	set firewall.samba_tcp.dest_port='139 445'
	set firewall.samba_tcp.name='网络共享tcp'

	set firewall.ssh=rule
	set firewall.ssh.target='ACCEPT'
	set firewall.ssh.src='wan'
	set firewall.ssh.proto='tcp'
	set firewall.ssh.dest_port='22'
	set firewall.ssh.name='ssh'

	set firewall.aria2=rule
	set firewall.aria2.target='ACCEPT'
	set firewall.aria2.src='wan'
	set firewall.aria2.proto='tcp'
	set firewall.aria2.dest_port='6800'
	set firewall.aria2.name='aria2'

	set firewall.AdGuardHome=rule
	set firewall.AdGuardHome.target='ACCEPT'
	set firewall.AdGuardHome.src='wan'
	set firewall.AdGuardHome.proto='tcp'
	set firewall.AdGuardHome.dest_port='3600'
	set firewall.AdGuardHome.name='adg广告过滤'

	set firewall.vsftpd=rule
	set firewall.vsftpd.target='ACCEPT'
	set firewall.vsftpd.src='wan'
	set firewall.vsftpd.proto='tcp'
	set firewall.vsftpd.dest_port='21 50000-51000'
	set firewall.vsftpd.name='ftp共享'

	commit firewall
EOF
#service firewall reload
echo  "${tag}" "【${tit}】$((h4=h4+1))：" "添加防火墙rule"

exit 0