#!/bin/sh

[ -x "/etc/init.d/wifidogx" ] || exit 0
[ -f "/etc/config/wifidogx" ] || touch /etc/config/wifidogx

#第二行后面插入pwd
#apfree-wifidog_4.08.1771-4 修复bug
#sed -i '2apwd' /etc/init.d/wifidogx
[ ! -f /mnt/sda1/112.txt ] && touch /mnt/sda1/112.txt
echo "重设wifidogx" >> /mnt/sda1/112.txt
sed -i '/" "disabled"/s/0/1/g' /etc/init.d/wifidogx
sed -i '/= "0" ]; then/s/0/1/g' /etc/init.d/wifidogx
sed -i '/if.*APFREE_/s/-s/! &/g' /etc/init.d/wifidogx
sed -i '/if.*APFREE_/s/\&/|/g' /etc/init.d/wifidogx

uci -q batch <<-EOF >/dev/null
	 set wifidogx.@wifidog[0]=wifidog
	 set wifidogx.@wifidog[0].gateway_interface='br-lan'
	 set wifidogx.@wifidog[0].auth_server_path='/wifidog/'
	 set wifidogx.@wifidog[0].check_interval='60'
	 set wifidogx.@wifidog[0].client_timeout='5'
#有线通过
	 set wifidogx.@wifidog[0].wired_passed='1'
	 set wifidogx.@wifidog[0].auth_server_hostname='192.168.200.1'
	 set wifidogx.@wifidog[0].auth_server_port='80'
#是否禁用
	 set wifidogx.@wifidog[0].disabled='0'
#线程池模式
	 set wifidogx.@wifidog[0].pool_mode='1'
#线程号
	 set wifidogx.@wifidog[0].thread_number='5'
#队列大小
	 set wifidogx.@wifidog[0].queue_size='20'
	 set wifidogx.@wifidog[0].enable='1'
	 commit wifidogx
EOF

service wifidogx restart | tee -ai /mnt/sda1/112.txt
service wifidogx stop
