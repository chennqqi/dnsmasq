#!/bin/sh
echo
wgetroute="/usr/bin/wget-ssl"
CRON_FILE=/etc/crontabs/$USER
clear
echo
echo "# Copyright (c) 2014-2017,by clion007"
echo
echo "# 本脚本仅用于个人研究与学习使用，从未用于产生任何盈利（包括“捐赠”等方式）"
echo "# 未经许可，请勿内置于软件内发布与传播！请勿用于产生盈利活动！请遵守当地法律法规，文明上网。"
echo "# openwrt类固件使用，包括但不限于pandorabox、LEDE、ddwrt、明月、石像鬼等，华硕、老毛子、梅林等Padavan系列固件慎用。"
echo -e "# 安装前请\e[1;31m备份原配置\e[0m；安装过程中需要输入路由器相关配置信息，由此产生的一切后果自行承担！"
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                                                          +"
echo "+     Install Fq+Noad for OpnWrt or LEDE or PandoraBox     +"
echo "+                                                          +"
echo "+                      Time:`date +'%Y-%m-%d'`                     +"
echo "+                                                          +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo -e "\e[1;36m 三秒后开始安装......\e[0m"
echo
sleep 3
echo -e "\e[1;36m 创建dnsmasq规则与更新脚本存放的文件夹\e[0m"
echo
echo -e "\e[1;36m 检测和备份当前dnsmasq配置信息\e[0m"
if [ -d /etc/dnsmasq ]; then
	mv -f /etc/dnsmasq /etc/dnsmasq.bak
fi
if [ -d /etc/dnsmasq.d ]; then
	mv -f /etc/dnsmasq.d /etc/dnsmasq.d.bak
fi
mkdir -p /etc/dnsmasq
mkdir -p /etc/dnsmasq.d
echo
sleep 3
echo -e "\e[1;36m 配置dnsmasq\e[0m"
if [ -f /etc/dnsmasq.conf ]; then
	mv -f /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
fi
echo
lanip=$(ifconfig |grep Bcast|awk '{print $2}'|tr -d "addr:")
echo -e "\e[1;36m 路由器网关:$lanip\e[0m"
echo "# 添加监听地址（其中$lanip为你的lan网关ip）
listen-address=$lanip,127.0.0.1

# 并发查询所有上游DNS服务器
all-servers 

# 指定上游DNS服务器配置文件路径
resolv-file=/etc/dnsmasq/resolv.conf

# 添加额外hosts规则路径
addn-hosts=/etc/dnsmasq/noad.conf

# IP反查域名
bogus-priv

# 添加DNS解析文件
conf-file=/etc/dnsmasq.d/fqad.conf

# 设定域名解析缓存池大小
cache-size=10000" > /etc/dnsmasq.conf
echo
sleep 3
echo -e "\e[1;36m 创建上游DNS配置文件\e[0m"
echo "# 上游DNS解析服务器
# 如需根据自己的网络环境优化DNS服务器，可用ping或DNSBench测速
# 选择最快的服务器，打开resolv文件依次按速度快慢顺序手动改写
nameserver 127.0.0.1" > /etc/dnsmasq/resolv
cat /tmp/resolv.conf.ppp /etc/dnsmasq/resolv > /etc/dnsmasq/resolv.conf
rm -rf /etc/dnsmasq/resolv
echo "nameserver 218.30.118.6
nameserver 8.8.4.4
nameserver 119.29.29.29
nameserver 4.2.2.2
nameserver 114.114.114.114
nameserver 1.2.4.8
nameserver 223.5.5.5
nameserver 114.114.114.119" >> /etc/dnsmasq/resolv.conf
echo
sleep 3
echo -e "\e[1;36m 创建自定义扶墙规则\e[0m"
echo "# 格式示例如下，删除address前 # 有效，添加自定义规则
# 正确ip地址表示DNS解析扶墙，127地址表示去广告
#address=/.001union.com/127.0.0.1
#address=/telegram.org/149.154.167.99" > /etc/dnsmasq.d/userlist
echo
echo -e "\e[1;36m 创建自定义广告黑名单\e[0m"
echo "# 请在下面添加广告黑名单
# 每行输入要屏蔽广告网址不含http://符号
active.admore.com.cn
g.163.com
mtty-cdn.mtty.com
static-alias-1.360buyimg.com
image.yzmg.com" > /etc/dnsmasq/blacklist
echo
echo -e "\e[1;36m 创建自定义广告白名单\e[0m"
echo "# ，请将误杀的网址添加到在下面白名单
# 每行输入相应的网址或关键词即可，建议尽量输入准确的网址
toutiao.com
dl.360safe.com
down.360safe.com
fd.shouji.360.cn
zhushou.360.cn
shouji.360.cn
hot.m.shouji.360tpcdn.com
jd.com
tejia.taobao.com
temai.taobao.com
ai.m.taobao.com
ai.taobao.com
re.taobao.com
shi.taobao.com
tv.sohu.com" > /etc/dnsmasq/whitelist
echo
echo -e "\e[1;36m 下载扶墙和广告规则\e[0m"
echo
echo -e "\e[1;36m 下载sy618扶墙规则\e[0m"
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/sy618 https://raw.githubusercontent.com/sy618/hosts/master/dnsmasq/dnsfq
echo
#echo -e "\e[1;36m 下载racaljk规则\e[0m"
#/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/racaljk https://raw.githubusercontent.com/racaljk/hosts/master/dnsmasq.conf
#echo
echo -e "\e[1;36m 下载vokins广告规则\e[0m"
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/ad.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf
echo
echo -e "\e[1;36m 下载easylistchina广告规则\e[0m"
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/easylistchina.conf https://c.nnjsx.cn/GL/dnsmasq/update/adblock/easylistchina.txt
echo
echo -e "\e[1;36m 下载yhosts缓存\e[0m"
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/yhosts.conf https://raw.githubusercontent.com/vokins/yhosts/master/hosts.txt
echo
echo -e "\e[1;36m 下载malwaredomainlist规则\e[0m"
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/malwaredomainlist.conf http://www.malwaredomainlist.com/hostslist/hosts.txt && sed -i "s/.$//g" /tmp/malwaredomainlist.conf
echo
echo -e "\e[1;36m 下载adaway规则缓存\e[0m"
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/adaway https://adaway.org/hosts.txt
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/adaway2 http://winhelp2002.mvps.org/hosts.txt && sed -i "s/.$//g" /tmp/adaway2
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/adaway3 http://77l5b4.com1.z0.glb.clouddn.com/hosts.txt
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/adaway4 https://hosts-file.net/ad_servers.txt && sed -i "s/.$//g" /tmp/adaway4
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/adaway5 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=o&mimetype=plaintext'
cat /tmp/adaway /tmp/adaway2 /tmp/adaway3 /tmp/adaway4 /tmp/adaway5 > /tmp/adaway.conf
rm -rf /tmp/adaway
rm -rf /tmp/adaway2
rm -rf /tmp/adaway3
rm -rf /tmp/adaway4
rm -rf /tmp/adaway5
echo
sleep 3
#echo -e "\e[1;36m 删除racaljk规则中的冲突规则\e[0m"
#sed -i '/google/d' /tmp/racaljk
#sed -i '/youtube/d' /tmp/racaljk
#echo
echo -e "\e[1;36m 创建用户自定规则缓存\e[0m"
cp /etc/dnsmasq.d/userlist /tmp/userlist
echo
echo -e "\e[1;36m 创建自定义广告黑名单缓存\e[0m"
cp /etc/dnsmasq/blacklist /tmp/blacklist
sed -i "/#/d" /tmp/blacklist
sed -i 's/^/127.0.0.1 &/g' /tmp/blacklist
echo
echo -e "\e[1;36m 合并dnsmasq'hosts缓存\e[0m"
#cat /tmp/userlist /tmp/racaljk /tmp/sy618 /tmp/ad.conf /tmp/easylistchina.conf > /tmp/fqad
cat /tmp/userlist /tmp/sy618 /tmp/ad.conf /tmp/easylistchina.conf > /tmp/fqad
cat /tmp/blacklist /tmp/yhosts.conf /tmp/adaway.conf /tmp/malwaredomainlist.conf > /tmp/noad
echo
echo -e "\e[1;36m 删除dnsmasq'hosts临时文件\e[0m"
rm -rf /tmp/userlist
rm -rf /tmp/ad.conf
rm -rf /tmp/sy618
rm -rf /tmp/easylistchina.conf
#rm -rf /tmp/racaljk
rm -rf /tmp/blacklist
rm -rf /tmp/yhosts.conf
rm -rf /tmp/adaway.conf
rm -rf /tmp/malwaredomainlist.conf
echo
echo -e "\e[1;36m 删除被误杀的广告规则\e[0m"
while read -r line
do
	sed -i "/$line/d" /tmp/noad
	sed -i "/$line/d" /tmp/fqad
done < /etc/dnsmasq/whitelist
echo
echo -e "\e[1;36m 删除注释和本地规则\e[0m"
sed -i '/::1/d' /tmp/fqad
sed -i '/localhost/d' /tmp/fqad
sed -i '/# /d' /tmp/fqad
sed -i '/#★/d' /tmp/fqad
sed -i '/#address/d' /tmp/fqad
sed -i '/#/d' /tmp/noad
sed -i '/@/d' /tmp/noad
sed -i '/::1/d' /tmp/noad
sed -i '/localhost/d' /tmp/noad
echo
echo -e "\e[1;36m 统一广告规则格式\e[0m"
sed -i "s/0.0.0.0/127.0.0.1/g" /tmp/fqad
sed -i "s/  / /g" /tmp/fqad
sed -i "s/  / /g" /tmp/noad
sed -i "s/	/ /g" /tmp/noad
sed -i "s/0.0.0.0/127.0.0.1/g" /tmp/noad
echo
echo -e "\e[1;36m 创建dnsmasq规则文件\e[0m"
echo "
############################################################
## 【Copyright (c) 2014-2017, clion007】                          ##
##                                                                ##
## 感谢https://github.com/sy618/hosts                             ##
## 感谢https://github.com/racaljk/hosts                           ##
####################################################################

# Localhost (DO NOT REMOVE) Start
address=/localhost/127.0.0.1
address=/localhost/::1
address=/ip6-localhost/::1
address=/ip6-loopback/::1
# Localhost (DO NOT REMOVE) End

# Modified DNS start
" > /etc/dnsmasq.d/fqad.conf # 换成echo的方式注入
echo
echo -e "\e[1;36m 创建hosts规则文件\e[0m"
echo "
############################################################
## 【Copyright (c) 2014-2017, clion007】                          ##
##                                                                ##
## 感谢https://github.com/sy618/hosts                             ##
## 感谢https://github.com/vokins/hosts                            ##
## 感谢https://github.com/racaljk/hosts                           ##
####################################################################

# 默认hosts开始（想恢复最初状态的hosts，只保留下面两行即可）
127.0.0.1 localhost
::1	localhost
::1	ip6-localhost
::1	ip6-loopback
# 默认hosts结束

# 修饰hosts开始
" > /etc/dnsmasq/noad.conf # 换成echo的方式注入
echo
echo -e "\e[1;36m 删除dnsmasq'hosts重复规则及临时文件\e[0m"
sort /tmp/fqad | uniq >> /etc/dnsmasq.d/fqad.conf
sort /tmp/noad | uniq >> /etc/dnsmasq/noad.conf
rm -rf /tmp/fqad
rm -rf /tmp/noad
echo "# Modified DNS end" >> /etc/dnsmasq.d/fqad.conf
echo "# 修饰hosts结束" >> /etc/dnsmasq/noad.conf
echo
sleep 3
echo -e "\e[1;36m 重启dnsmasq服务\e[0m"
#killall dnsmasq
	/etc/init.d/dnsmasq restart > /dev/null 2>&1
echo
sleep 2
echo -e "\e[1;36m 获取脚本更新脚本\e[0m"
wget --no-check-certificate -q -O /etc/dnsmasq/fqad_update.sh https://raw.githubusercontent.com/clion007/dnsmasq/master/fqad_update.sh
echo
echo -e "\e[1;36m 获取规则更新脚本\e[0m"
wget --no-check-certificate -q -O /etc/dnsmasq/fqadrules_update.sh https://raw.githubusercontent.com/clion007/dnsmasq/master/fqadrules_update.sh
echo
sleep 1
echo -e "\e[1;31m 添加计划任务\e[0m"
chmod 755 /etc/dnsmasq/fqad_update.sh
sed -i '/dnsmasq/d' $CRON_FILE
sed -i '/@/d' $CRON_FILE
echo
echo -e -n "\e[1;36m 请输入更新时间(整点小时): \e[0m" 
read timedata
echo "$timedata" > /etc/crontabs/Update_time.conf
echo "[$USER@$HOSTNAME:/$USER]#cat /etc/crontabs/$USER
# 每天$timedata点28分更新翻墙和广告规则
28 $timedata * * * /bin/sh /etc/dnsmasq/fqad_update.sh > /dev/null 2>&1" >> $CRON_FILE
/etc/init.d/cron reload
echo
echo -e "\e[1;36m 定时计划任务添加完成！\e[0m"
echo
echo -e "\e[1;36m 创建脚本更新检测副本\e[0m"
wget --no-check-certificate -q -O /etc/dnsmasq/fqad_auto.sh https://raw.githubusercontent.com/clion007/dnsmasq/master/fqad_auto.sh
echo
clear
sleep 1
echo
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                                                          +"
echo "+                 installation is complete                 +"
echo "+                                                          +"
echo "+                     Time:`date +'%Y-%m-%d'`                      +"
echo "+                                                          +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo
rm -f /tmp/fqad.sh
echo -e -n "\e[1;31m 是否需要重启路由器？[y/n]：\e[0m" 
read boot
if [ "$boot" = "y" ];then
	reboot
	else
	exit 0
fi
echo
