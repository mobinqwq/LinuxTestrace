#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: VPS综合脚本
# Version: 0.2
# Author: YE
# Blog:   https://imyee.cn
# From: nanqinlang-testrace
#======================================
${Font_suffix}"

check_system(){
	if   [[ ! -z "`cat /etc/issue | grep -iE "debian"`" ]]; then
		apt-get install traceroute mtr -y
	elif [[ ! -z "`cat /etc/issue | grep -iE "ubuntu"`" ]]; then
		apt-get install traceroute mtr -y
	elif [[ ! -z "`cat /etc/redhat-release | grep -iE "CentOS"`" ]]; then
		yum install traceroute mtr -y
	else
		echo -e "${Error} system not support!" && exit 1
	fi
}
check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}
directory(){
	[[ ! -d /home/testrace ]] && mkdir -p /home/testrace
	cd /home/testrace
}
install(){
	[[ ! -d /home/testrace/besttrace ]] && wget https://raw.githubusercontent.com/nanqinlang-script/testrace/master/besttrace.tar.gz && tar -zxf besttrace.tar.gz && rm besttrace.tar.gz
	[[ ! -d /home/testrace/besttrace ]] && echo -e "${Error} download failed, please check!" && exit 1
	chmod -R +x /home/testrace
}



test_single(){
	echo -e "${Info} 请输入你要测试的目标 ip :"
	read -p "输入 ip 地址:" ip

	while [[ -z "${ip}" ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "输入 ip 地址:" ip
		done

	./besttrace -q 1 ${ip} | tee -a -i /home/testrace/testrace.log 2>/dev/null

	repeat_test_single
}
repeat_test_single(){
	echo -e "${Info} 是否继续测试其他目标 ip ?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_single
	while [[ ! "${whether_repeat_single}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_single
		done
	[[ "${whether_repeat_single}" == "1" ]] && test_single
	[[ "${whether_repeat_single}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}


test_all(){
    
	result_all	'101.69.121.120'	'浙江嘉兴联通'
	result_all	'112.13.113.199'	'浙江杭州移动'
	result_all	'122.246.3.203' 	'浙江宁波电信'

	result_all	'58.251.150.50'		'广东深圳联通'
	result_all	'183.232.196.189'	'广东佛山移动'
	result_all	'61.142.166.245'	'广东佛山电信'

	result_all	'202.205.6.30'		'北京教育网'
	result_all	'202.112.14.151'	'成都教育网'
	result_all	'210.32.158.231'	'浙江教育网'
	
	result_all	'61.237.254.1'	    '北京铁通'  
	result_all	'61.237.123.209'    '广东广州铁通'
	result_all	'115.47.150.101'    '北京鹏博士'
	
	result_all	'120.55.199.144'    '浙江杭州阿里云BGP'
	result_all	'118.24.215.0'      '重庆重庆腾讯云BGP'
	result_all	'43.254.0.6'        '北京北京华为云BGP'

	echo -e "${Info} 六网路由快速测试 已完成 ！"
}

test_dx(){
    
	result_all	'122.246.3.203' 	'浙江宁波电信'
	result_all	'61.142.166.245'	'广东佛山电信'
	result_all	'183.66.105.184'	'重庆电信'
	result_all	'61.147.235.235'	'江苏南通电信'
	result_all	'42.81.120.110'	    '天津电信'
	result_all	'42.202.141.223'	'辽宁大连电信'
	result_all	'124.225.191.248'	'海南海口电信'
	result_all	'123.172.120.196'	'吉林长春电信'

	echo -e "${Info} 电信路由快速测试 已完成 ！"
}

test_lt(){
    
	result_all	'61.162.172.84' 	'山东烟台联通'
	result_all	'101.206.209.213'	'四川成都联通'
	result_all	'157.255.134.75'	'广东东莞联通'
	result_all	'218.98.10.122'	    '江苏苏州联通'
	result_all	'121.31.30.201'	    '广西西宁联通'
	result_all	'125.211.204.209'	'黑龙江哈尔滨联通'
	result_all	'123.6.2.101'	    '河南郑州联通'
	result_all	'58.144.136.143'	'重庆联通'

	echo -e "${Info} 联通路由快速测试 已完成 ！"
}

test_yd(){
    
	result_all	'120.221.177.252' 	'山东济南移动'
	result_all	'112.25.105.102'	'江苏南京移动'
	result_all	'112.29.151.180'	'安徽合肥移动'
	result_all	'183.232.152.112'   '广东深圳移动'
	result_all	'111.62.39.229'     '河北石家庄移动'
    result_all	'211.137.133.67'    '陕西西安移动'

	echo -e "${Info} 移动路由快速测试 已完成 ！"
}





result_all(){
	ISP_name=$2
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./besttrace -q 1 $1
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"
}

test_beach(){
# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }



# Check release
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi


# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SKYBLUE='\033[0;36m'
PLAIN='\033[0m'

rm -rf /tmp/report && mkdir /tmp/report

echo "正在安装必要的依赖，请耐心等待..."



# Install Virt-what
if  [ ! -e '/usr/sbin/virt-what' ]; then
    echo "Installing Virt-What......"
    if [ "${release}" == "centos" ]; then
        yum -y install virt-what > /dev/null 2>&1
    else
        apt-get update
        apt-get -y install virt-what > /dev/null 2>&1
    fi
fi

# Install uuid
echo "Installing uuid......"
if [ "${release}" == "centos" ]; then
    yum -y install uuid > /dev/null 2>&1
else
    apt-get -y install uuid > /dev/null 2>&1
fi


# Install curl
echo "Installing curl......"
if [ "${release}" == "centos" ]; then
    yum -y install curl > /dev/null 2>&1
else
    apt-get -y install curl > /dev/null 2>&1
fi


# Install Besttrace
if  [ ! -e '/tmp/besttrace' ]; then
    echo "Installing Besttrace......"
    dir=$(pwd)
    cd /tmp/
    wget  -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/ZBench/master/besttrace > /dev/null 2>&1
    cd $dir
fi
chmod a+rx /tmp/besttrace

# Check Python
if  [ ! -e '/usr/bin/python' ]; then
    echo "Installing Python......"
    if [ "${release}" == "centos" ]; then
            yum update > /dev/null 2>&1
            yum -y install python
        else
            apt-get update > /dev/null 2>&1
            apt-get -y install python
    fi
fi

# Install Speedtest
if  [ ! -e '/tmp/speedtest.py' ]; then
    echo "Installing SpeedTest......"
    dir=$(pwd)
    cd /tmp/
    wget -N --no-check-certificate https://raw.github.com/sivel/speedtest-cli/master/speedtest.py > /dev/null 2>&1
    cd $dir
fi
chmod a+rx /tmp/speedtest.py


# Install Zping-CN
if  [ ! -e '/tmp/ZPing-CN.py' ]; then
    echo "Installing ZPing-CN.py......"
    dir=$(pwd)
    cd /tmp/
    wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/ZBench/master/ZPing-CN.py > /dev/null 2>&1
    cd $dir
fi
chmod a+rx /tmp/ZPing-CN.py

#"TraceRoute to Shanghai Telecom"
/tmp/besttrace 61.129.42.6 > /tmp/sht.txt 2>&1 &
#"TraceRoute to Shanghai Mobile"
/tmp/besttrace speedtest2.sh.chinamobile.com > /tmp/shm.txt 2>&1 &
#"TraceRoute to Shanghai Unicom"
/tmp/besttrace 210.22.80.1 > /tmp/shu.txt 2>&1 &
#"TraceRoute to Guangdong Telecom"
/tmp/besttrace 121.14.220.240 > /tmp/gdt.txt 2>&1 &
#"TraceRoute to Guangdong Mobile"
/tmp/besttrace 211.136.192.6 > /tmp/gdm.txt 2>&1 &
#"TraceRoute to Guangdong Unicom"
/tmp/besttrace 221.5.88.88 > /tmp/gdu.txt 2>&1 &
#"TraceRoute to Owner's Network"
/tmp/besttrace ${OwnerIP} > /tmp/own.txt 2>&1 &




get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-74s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    local speedtest=$(wget -4O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    local ipaddress=$(ping -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    local nodeName=$2
    local latency=$(ping $ipaddress -c 3 | grep avg | awk -F / '{print $5}')" ms"
    printf "${YELLOW}%-26s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${ipaddress}" "${speedtest}" "${latency}"

    #Record Speed Data
    echo ${ipaddress} >> /tmp/speed.txt
    echo ${speedtest} >> /tmp/speed.txt
    echo ${latency} >> /tmp/speed.txt
}

speed() {
    speed_test 'http://cachefly.cachefly.net/100mb.test' 'CacheFly'
    speed_test 'http://speedtest.tokyo.linode.com/100MB-tokyo.bin' 'Linode, Tokyo, JP'
    speed_test 'http://speedtest.singapore.linode.com/100MB-singapore.bin' 'Linode, Singapore, SG'
    speed_test 'http://speedtest.london.linode.com/100MB-london.bin' 'Linode, London, UK'
    speed_test 'http://speedtest.frankfurt.linode.com/100MB-frankfurt.bin' 'Linode, Frankfurt, DE'
    speed_test 'http://speedtest.fremont.linode.com/100MB-fremont.bin' 'Linode, Fremont, CA'
    speed_test 'http://speedtest.dal05.softlayer.com/downloads/test100.zip' 'Softlayer, Dallas, TX'
    speed_test 'http://speedtest.sea01.softlayer.com/downloads/test100.zip' 'Softlayer, Seattle, WA'
    speed_test 'http://speedtest.sng01.softlayer.com/downloads/test100.zip' 'Softlayer, Singapore, SG'
    speed_test 'http://speedtest.hkg02.softlayer.com/downloads/test100.zip' 'Softlayer, HongKong, CN'
	speed_test 'http://tor-ca-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, Toronto, CAN'
	speed_test 'http://lax-ca-us-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, LosAngeles, US'
	speed_test 'http://syd-au-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, Sydney, Australia'
	speed_test 'http://sj.lg.virmach.com/100MB.test' 'Virmach, San Jose, US'
}

speed_test_cn(){
    if [[ $1 == '' ]]; then
        temp=$(python /tmp/speedtest.py --share 2>&1)
        is_down=$(echo "$temp" | grep 'Download')
        if [[ ${is_down} ]]; then
            local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
            local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
            local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
            local nodeName=$2

            printf "${YELLOW}%-29s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
        else
            local cerror="ERROR"
        fi
    else
        temp=$(python /tmp/speedtest.py --server $1 --share 2>&1)
        is_down=$(echo "$temp" | grep 'Download')
        if [[ ${is_down} ]]; then
            local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
            local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
            local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
            temp=$(echo "$relatency" | awk -F '.' '{print $1}')
            if [[ ${temp} -gt 1000 ]]; then
                relatency=" 000.000 ms"
            fi
            local nodeName=$2

            printf "${YELLOW}%-29s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
        else
            local cerror="ERROR"
        fi
    fi

    #Record Speed_cn Data
    echo ${reupload} >> /tmp/speed_cn.txt
    echo ${REDownload} >> /tmp/speed_cn.txt
    echo ${relatency} >> /tmp/speed_cn.txt
}

speed_cn() {

    speed_test_cn '12637' '襄阳电信'
    speed_test_cn '3633' '上海电信'
    speed_test_cn '4624' '成都电信'
	speed_test_cn '4751' "北京电信"
    speed_test_cn '4863' "西安电信"
    speed_test_cn '5083' '上海联通'
    speed_test_cn '5726' '重庆联通'
    speed_test_cn '5145' '北京联通'
    
    rm -rf /tmp/speedtest.py
}


io_test() {
    (LANG=C dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}
    do
        [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
        [ "`echo ${size:(-1)}`" == "K" ] && size=0
        [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
        [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
        [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
        total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
    done
    echo ${total_size}
}

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
swap=$( free -m | awk '/Swap/ {print $2}' )
uswap=$( free -m | awk '/Swap/ {print $3}' )
up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days, %d hour %d min\n",a,b,c)}' /proc/uptime )
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
ipv6=$( wget -qO- -t1 -T2 ipv6.icanhazip.com )
disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )


clear
next
echo -e "CPU 型号             : ${SKYBLUE}$cname${PLAIN}"
echo -e "CPU 核心数           : ${SKYBLUE}$cores${PLAIN}"
echo -e "CPU 频率             : ${SKYBLUE}$freq MHz${PLAIN}"
echo -e "总硬盘大小           : ${SKYBLUE}$disk_total_size GB ($disk_used_size GB Used)${PLAIN}"
echo -e "总内存大小           : ${SKYBLUE}$tram MB ($uram MB Used)${PLAIN}"
echo -e "SWAP大小             : ${SKYBLUE}$swap MB ($uswap MB Used)${PLAIN}"
echo -e "开机时长             : ${SKYBLUE}$up${PLAIN}"
echo -e "系统负载             : ${SKYBLUE}$load${PLAIN}"
echo -e "系统                 : ${SKYBLUE}$opsy${PLAIN}"
echo -e "架构                 : ${SKYBLUE}$arch ($lbit Bit)${PLAIN}"
echo -e "内核                 : ${SKYBLUE}$kern${PLAIN}"
echo -ne "虚拟化平台           : "
virtua=$(virt-what) 2>/dev/null

if [[ ${virtua} ]]; then
    echo -e "${SKYBLUE}$virtua${PLAIN}"
else
    echo -e "${SKYBLUE}No Virt${PLAIN}"
fi


next
io1=$( io_test )
echo -e "硬盘I/O (第一次测试) : ${YELLOW}$io1${PLAIN}"
io2=$( io_test )
echo -e "硬盘I/O (第二次测试) : ${YELLOW}$io2${PLAIN}"
io3=$( io_test )
echo -e "硬盘I/O (第三次测试) : ${YELLOW}$io3${PLAIN}"
next

##Record All Test data
rm -rf /tmp/info.txt
touch /tmp/info.txt
echo $cname >> /tmp/info.txt
echo $cores >> /tmp/info.txt
echo $freq MHz >> /tmp/info.txt
echo "$disk_total_size GB ($disk_used_size GB 已使用) ">> /tmp/info.txt
echo "$tram MB ($uram MB 已使用) ">> /tmp/info.txt
echo "$swap MB ($uswap MB 已使用)" >> /tmp/info.txt
echo $up >> /tmp/info.txt
echo $load >> /tmp/info.txt
echo $opsy >> /tmp/info.txt
echo "$arch ($lbit 位) ">> /tmp/info.txt
echo $kern >> /tmp/info.txt
echo $virtua >> /tmp/info.txt
echo $io1 >> /tmp/info.txt
echo $io2 >> /tmp/info.txt
echo $io3 >> /tmp/info.txt
AKEY=$( uuid )

printf "%-30s%-20s%-24s%-12s\n" "节点名称" "IP地址" "下载速度" "延迟"
speed && next
printf "%-30s%-22s%-24s%-12s\n" "节点名称" "上传速度" "下载速度" "延迟"
speed_cn && next
python /tmp/ZPing-CN.py
next

NetCFspeec=$( sed -n "2p" /tmp/speed.txt )
NetCFping=$( sed -n "3p" /tmp/speed.txt )
NetLJPspeed=$( sed -n "5p" /tmp/speed.txt )
NetLJPping=$( sed -n "6p" /tmp/speed.txt )
NetLSGspeed=$( sed -n "8p" /tmp/speed.txt )
NetLSGping=$( sed -n "9p" /tmp/speed.txt )
NetLUKspeed=$( sed -n "11p" /tmp/speed.txt )
NetLUKping=$( sed -n "12p" /tmp/speed.txt )
NetLDEspeed=$( sed -n "14p" /tmp/speed.txt )
NetLDEping=$( sed -n "15p" /tmp/speed.txt )
NetLCAspeed=$( sed -n "17p" /tmp/speed.txt )
NetLCAping=$( sed -n "18p" /tmp/speed.txt )
NetSTXspeed=$( sed -n "20p" /tmp/speed.txt )
NetSTXping=$( sed -n "21p" /tmp/speed.txt )
NetSWAspeed=$( sed -n "23p" /tmp/speed.txt )
NetSWAping=$( sed -n "24p" /tmp/speed.txt )
NetSDEspeed=$( sed -n "26p" /tmp/speed.txt )
NetSDEping=$( sed -n "27p" /tmp/speed.txt )
NetSSGspeed=$( sed -n "29p" /tmp/speed.txt )
NetSSGping=$( sed -n "30p" /tmp/speed.txt )
NetSCNspeed=$( sed -n "32p" /tmp/speed.txt )
NetSCNping=$( sed -n "33p" /tmp/speed.txt )


NetUPST=$( sed -n "4p" /tmp/speed_cn.txt )
NetDWST=$( sed -n "5p" /tmp/speed_cn.txt )
NetPiST=$( sed -n "6p" /tmp/speed_cn.txt )
NetUPCT=$( sed -n "7p" /tmp/speed_cn.txt )
NetDWCT=$( sed -n "8p" /tmp/speed_cn.txt )
NetPiCT=$( sed -n "9p" /tmp/speed_cn.txt )
NetUPXT=$( sed -n "10p" /tmp/speed_cn.txt )
NetDWXT=$( sed -n "11p" /tmp/speed_cn.txt )
NetPiXT=$( sed -n "12p" /tmp/speed_cn.txt )
NetUPSU=$( sed -n "13p" /tmp/speed_cn.txt )
NetDWSU=$( sed -n "14p" /tmp/speed_cn.txt )
NetPiSU=$( sed -n "15p" /tmp/speed_cn.txt )
NetUPCU=$( sed -n "16p" /tmp/speed_cn.txt )
NetDWCU=$( sed -n "17p" /tmp/speed_cn.txt )
NetPiCU=$( sed -n "18p" /tmp/speed_cn.txt )
NetUPXM=$( sed -n "19p" /tmp/speed_cn.txt )
NetDWXM=$( sed -n "20p" /tmp/speed_cn.txt )
NetPiXM=$( sed -n "21p" /tmp/speed_cn.txt )
NetUPSM=$( sed -n "22p" /tmp/speed_cn.txt )
NetDWSM=$( sed -n "23p" /tmp/speed_cn.txt )
NetPiSM=$( sed -n "24p" /tmp/speed_cn.txt )
NetUPCM=$( sed -n "25p" /tmp/speed_cn.txt )
NetDWCM=$( sed -n "26p" /tmp/speed_cn.txt )
NetPiCM=$( sed -n "27p" /tmp/speed_cn.txt )


wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/ZBench/master/Generate.py >> /dev/null 2>&1
python Generate.py && rm -rf Generate.py && cp /root/report.html /tmp/report/index.html
TSM=$( cat /tmp/shm.txt_table )
TST=$( cat /tmp/sht.txt_table )
TSU=$( cat /tmp/shu.txt_table )
TGM=$( cat /tmp/gdm.txt_table )
TGT=$( cat /tmp/gdt.txt_table )
TGU=$( cat /tmp/gdu.txt_table )
curl 'http://api.zbench.kirito.moe/action.php' --data "CPUmodel=$cname &CPUspeed=$freq MHz &CPUcore=$cores &HDDsize=$disk_total_size GB ($disk_used_size GB 已使用) &RAMsize=$tram MB ($uram MB 已使用)&SWAPsize=$swap MB ($uswap MB 已使用)&UPtime= $up&Arch=1&systemload=$load&OS= $opsy &Arch=$arch ($lbit 位)&Kernel=$kern &Virmethod=$virtua &IOa=$io1&IOb=$io2&IOc=$io3&NetCFspeec=$NetCFspeec&NetCFping=$NetCFping&NetLJPspeed=$NetLJPspeed&NetLJPping=$NetLJPping&NetLSGspeed=$NetLSGspeed&NetLSGping=$NetLSGping&NetLUKspeed=$NetLUKspeed&NetLUKping=$NetLUKping&NetLDEspeed=$NetLDEspeed&NetLDEping=$NetLDEping&NetLCAspeed=$NetLCAspeed&NetLCAping=$NetLCAping&NetSTXspeed=$NetSTXspeed&NetSTXping=$NetSTXping&NetSWAspeed=$NetSWAspeed&NetSWAping=$NetSWAping&NetSDEspeed=$NetSDEspeed&NetSDEping=$NetSDEping&NetSSGspeed=$NetSSGspeed&NetSSGping=$NetSSGping&NetSCNspeed=$NetSCNspeed&NetSCNping=$NetSCNping&NetUPST=$NetUPST&NetDWST=$NetDWST&NetPiST=$NetPiST&NetUPCT=$NetUPCT&NetDWCT=$NetDWCT&NetPiCT=$NetPiCT&NetUPXT=$NetUPXT&NetDWXT=$NetDWXT&NetPiXT=$NetPiXT&NetUPSU=$NetUPSU&NetDWSU=$NetDWSU&NetPiSU=$NetPiSU&NetUPCU=$NetUPCU&NetDWCU=$NetDWCU&NetPiCU=$NetPiCU&NetUPXM=$NetUPXM&NetDWXM=$NetDWXM&NetPiXM=$NetPiXM&NetUPSM=$NetUPSM&NetDWSM=$NetDWSM&NetPiSM=$NetPiSM&NetUPCM=$NetUPCM&NetDWCM=$NetDWCM&NetPiCM=$NetPiCM&TSM=$TSM&TST=$TST&TSU=$TSU&TGM=$TGM&TGT=$TGT&TGU=$TGU&AKEY=$AKEY&Provider=$Provider"
IKEY=$(curl "http://api.zbench.kirito.moe/getkey.php?AKEY=$AKEY" 2>/dev/null)
echo "在线查看测评报告：https://zbench.kirito.moe/record-cn.php?IKEY=$IKEY"
echo "您的测评报告已保存在 /root/report.html"

# If use simple http server
while :; do echo
  read -p "你想现在查看您的测评报告吗? [y/n]: " ifreport
  if [[ ! $ifreport =~ ^[y,n]$ ]]; then
    echo "输入错误! 请确保你输入的是 'y' 或者 'n'"
  else
    break
  fi
done

if [[ $ifreport == 'y' ]];then
    echo ""
    myip=`curl -m 10 -s http://members.3322.org/dyndns/getip`
    echo "访问 http://${myip}:8001/index.html 查看您的测试报告，按 Ctrl + C 退出"
	cd /tmp/report
    python -m SimpleHTTPServer 8001
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8001 -j ACCEPT
fi

}





check_system
check_root
directory
install
cd besttrace

echo -e "${Info} 选择你要使用的功能: "
echo -e "1.进行VPS综合测试\n2.全网路由快速测试(电信+联通+移动+教育网+铁通+鹏博士+BGP/共12个回程测试点)\n3.手动输入 ip 路由回程测试\n4.单独测试各地电信回程\n5.单独测试各地联通回程\n6.单独测试各地移动回程"
read -p "输入数字以选择:" function

	while [[ ! "${function}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 缺少或无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" function
		done

	if [[ "${function}" == "1" ]]; then
		test_beach
	elif [[ "${function}" == "2" ]]; then
		test_all | tee -a -i /home/testrace/testrace.log 2>/dev/null
	elif [[ "${function}" == "4" ]]; then
		test_dx | tee -a -i /home/testrace/testrace.log 3>/dev/null
	elif [[ "${function}" == "5" ]]; then
		test_lt | tee -a -i /home/testrace/testrace.log 3>/dev/null
	elif [[ "${function}" == "6" ]]; then
		test_yd | tee -a -i /home/testrace/testrace.log 3>/dev/null
	else
		test_single
	fi
