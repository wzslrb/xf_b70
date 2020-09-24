#!/bin/sh

unset wz hjbc nz
#初始化内置、外置脚本，有外置执行 unset gg
[ 0 -eq ${#h4} ] && export h4=0
[ 0 -eq ${#tag} ] && export tag="【$(echo $0)】"
[ ! 0 -eq ${#log} ] || [ -d /mnt/sda1 ] && export log="/mnt/sda1/112.txt" || export log="/tmp/112.txt"
[ 0 -eq ${#gg} ] && export gg=/tmp/bu_ji_xu	#跳过环境变量 创建touch $gg
export wz=/mnt/sda1/portal/uci-defaults		#外置脚本目录 unset
export nz=/root/uci-defaults			#内置脚本目录
export hjbc=/mnt/sda1/portal/zzzbc.sh		#后继补充脚本
export bdqd=/root/bdqd.sh			#本地启动脚本

echo "$tag" "/root/zzz-default-settings.sh" >> $log

if [[ -d $wz && -n "$(ls -A $wz)" ]]; then {
	echo "$tag" "发现外置存储$wz脚本目录，载入……" >> $log
	find $wz ! -type d -name "*" -exec /bin/bash {} \;
	#touch $gg	#创建跳过标志
}
else
	echo "$tag" "未发现外置存储$wz脚本目录，跳过……" >> $log
fi

if [ -e $gg ]; then {
	echo "$tag" "发现跳过标志，不再执行内置脚本……" >> $log
	rm -rf $gg
}
else {
	if [[ -d $nz && -n "$(ls -A $nz)" ]]; then {
		echo "$tag" "发现固件内置$nz脚本目录，载入……" >> $log
		find $nz ! -type d -name "*" -exec /bin/bash {} \;
	}
	else
		echo "$tag" "未发现固件内置$nz脚本目录……" >> $log
	fi
}
fi



if [ -s $hjbc ]; then {
	echo "$tag" "发现后继补充$hjbc，载入……" >> $log
	chmod +x $hjbc
	/bin/bash $hjbc
}
else
	echo "$tag" "未发现后继补充$hjbc ……" >> $log
fi

[ -s $bdqd ] && {
chmod +x $bdqd
sed -i "/^exit 0/i $bdqd" /etc/rc.local
echo  "${tag}" "添加本地启动脚本${bdqd}到/etc/rc.local" >> $log
}

exit 0

