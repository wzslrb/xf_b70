#!/bin/sh

[ -s "/etc/firewall.user" ] && {
echo 注释防火墙转发规则iptables 53 >> /mnt/sda1/112.txt
sed -i '/^[^#]/s/.*/# &/' /etc/firewall.user
service firewall reload | tee -ai /mnt/sda1/112.txt
} 

echo 防火墙rule规则 >> /mnt/sda1/112.txt

uci set firewall.web=rule
uci set firewall.web.target='ACCEPT'
uci set firewall.web.src='wan'
uci set firewall.web.proto='tcp'
uci set firewall.web.dest_port='80 443'
uci set firewall.web.name='外网web'

uci set firewall.samba_udp=rule
uci set firewall.samba_udp.target='ACCEPT'
uci set firewall.samba_udp.src='wan'
uci set firewall.samba_udp.proto='udp'
uci set firewall.samba_udp.dest_port='137-138'
uci set firewall.samba_udp.name='网络共享udp'

uci set firewall.samba_tcp=rule
uci set firewall.samba_tcp.target='ACCEPT'
uci set firewall.samba_tcp.src='wan'
uci set firewall.samba_tcp.proto='tcp'
uci set firewall.samba_tcp.dest_port='139 445'
uci set firewall.samba_tcp.name='网络共享tcp'

uci set firewall.ssh=rule
uci set firewall.ssh.target='ACCEPT'
uci set firewall.ssh.src='wan'
uci set firewall.ssh.proto='tcp'
uci set firewall.ssh.dest_port='22'
uci set firewall.ssh.name='ssh'

uci set firewall.aria2=rule
uci set firewall.aria2.target='ACCEPT'
uci set firewall.aria2.src='wan'
uci set firewall.aria2.proto='tcp'
uci set firewall.aria2.dest_port='6800'
uci set firewall.aria2.name='aria2'

uci set firewall.AdGuardHome=rule
uci set firewall.AdGuardHome.target='ACCEPT'
uci set firewall.AdGuardHome.src='wan'
uci set firewall.AdGuardHome.proto='tcp'
uci set firewall.AdGuardHome.dest_port='3600'
uci set firewall.AdGuardHome.name='adg广告过滤'

uci set firewall.vsftpd=rule
uci set firewall.vsftpd.target='ACCEPT'
uci set firewall.vsftpd.src='wan'
uci set firewall.vsftpd.proto='tcp'
uci set firewall.vsftpd.dest_port='21 50000-51000'
uci set firewall.vsftpd.name='ftp共享'

uci commit firewall
service firewall reload
