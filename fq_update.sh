#!/bin/sh
echo
echo " Copyright (c) 2014-2017,by clion007"
echo
echo " 本脚本仅用于个人研究与学习使用，从未用于产生任何盈利（包括“捐赠”等方式）"
echo " 未经许可，请勿内置于软件内发布与传播！请勿用于产生盈利活动！请遵守当地法律法规，文明上网。"
echo
#LOGFILE=/tmp/fqad_update.log
#LOGSIZE=$(wc -c < $LOGFILE)
#if [ $LOGSIZE -ge 5000 ]; then
#	sed -i -e 1,10d $LOGFILE
#fi
echo -e "\e[1;36m 1秒钟后开始检测更新脚本\e[0m"
echo
wget --no-check-certificate https://raw.githubusercontent.com/clion007/dnsmasq/master/fq_auto.sh -O \
      /tmp/fq_auto.sh && chmod 775 /tmp/fq_auto.sh
if [ -s "/tmp/fq_auto.sh" ]; then
	if ( ! cmp -s /tmp/fq_auto.sh /etc/dnsmasq/fq_auto.sh ); then
		echo " `date +'%Y-%m-%d %H:%M:%S'`: 检测到脚本更新......3秒后即将开始更新！"
		echo
		sleep 3
		echo -e "\e[1;36m 开始更新翻墙脚本\e[0m"
		echo
		clear
		sh /tmp/fq_auto.sh
		echo " `date +'%Y-%m-%d %H:%M:%S'`: 脚本及规则更新完成。"
		else
		echo " `date +'%Y-%m-%d %H:%M:%S'`: 脚本无需更新，3秒后即将开始更新规则"
		rm -f /tmp/fq_auto.sh
		sh /etc/dnsmasq/fqrules_update.sh
	fi	
fi
echo
exit 0
