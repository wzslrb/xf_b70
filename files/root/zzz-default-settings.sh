#!/bin/sh

#初始化内置、外置脚本，有外置执行 unset gg
[ 0 -eq ${#h4} ] && export h4=0
[ 0 -eq ${#tag} ] && export tag="【$(echo $0)】"
[ ! 0 -eq ${#log} ] || [ -d /mnt/sda1 ] && export log="/mnt/sda1/112.txt" || export log="/tmp/112.txt"
[ 0 -eq ${#gg} ] && export gg=/tmp/bu_ji_xu	#跳过环境变量 创建touch $gg
export wz=/mnt/sda1/portal/uci-defaults		#外置脚本目录 unset
export nz=/root/uci-defaults			#内置脚本目录

echo "$tag" "/root/zzz-default-settings.sh" >> $log

if [[ -d $wz && ! -z "$wz" ]]; then {
	echo "$tag" "发现外置存储$wz脚本目录，载入……" >> $log
	find $wz -maxdepth 1 -type f -name "*.sh" -exec /bin/bash {} \;
	#touch $gg	#创建跳过标志
}
else
	echo "$tag" "未发现外置存储$wz脚本目录，跳过……" >> $log
fi

[ -e $gg ] && echo "$tag" "发现跳过标志，不再执行内置脚本，程序退出……" && rm -rf $gg && exit 0

if [[ -d $nz && ! -z "$nz" ]]; then {
	echo "$tag" "发现固件内置$wz脚本目录，载入……" >> $log
	find $nz -maxdepth 1 -type f -name "*.sh" -exec /bin/bash {} \;
}
else
	echo "$tag" "未发现固件内置$wz脚本目录，程序退出……" >> $log
fi

exit 0

