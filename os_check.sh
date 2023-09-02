#!/bin/sh
source /etc/profile
sysname="uds"
[ ! -d /tmp/${sysname}/OS ] && mkdir -p  /tmp/${sysname}/OS && chmod -R 775 /tmp/${sysname}
ip=`ip a|grep 10|grep inet|head -1 | awk -F " +|/" '{print $3}'`
logfile=/tmp/${sysname}/OS/${ip}_.txt


    df -iTPh|sed '1d'|awk '{print "主机-文件系统-逻辑卷-Inodes文件系统使用率:"$1,$6}' > $logfile
    df -TPh|sed '1d'|awk '{print "主机-文件系统-文件系统使用比率:"$1,$6}' >> $logfile

    echo "主机-文件系统-系统只读 `grep -w ro /proc/mounts |wc -l`" >> $logfile

    mem_total=`free -m | grep Mem | awk '{print $2}'`
    mem_used=`free -m | grep Mem | awk '{print $4 + $6}'`
    awk 'BEGIN{printf "主机-内存-内存的使用率 %.0f%%\n",('$mem_used'/'$mem_total')*100}' >> $logfile

    swap_total=`free -m | grep Swap | awk '{print $2}'`
    if [ $swap_total -gt 0 ];then
         swap_used=`free -m | grep Swap | awk '{print $3}'`
         awk 'BEGIN{printf "主机-内存-交换区使用百分比 %.0f%%\n",('$swap_used'/'$swap_total')*100}' >> $logfile
    else
        awk 'BEGIN{printf "主机-内存-交换区使用百分比 %.0f%%\n",0}' >> $logfile
    fi

    top -bn 3 | grep 'top -' -A 10 | tail -n 11 > /tmp/${sysname}/OS/top.log
    cat /tmp/${sysname}/OS/top.log|grep Cpu|awk  -F ' +|%' '{if($0~/^%/)print "主机-CPU使用率 "$3+$5+$7"%"; else print "主机-CPU使用率 "$2+$4+$6"%"}' >> $logfile

  iostat -x 1 3|grep '^dm'|awk 'BEING {max=0}{if ($NF>max)max=$NF}END{print "主机-磁盘IO消耗CPU百分比", max"%"}' >> $logfile

	#cpu1/5/15m负荷
    cpucore_num=`cat /proc/cpuinfo |grep "processor" |wc -l`    
    read a b c  <<<  $(uptime | awk -F" |," '{print $(NF-4), $(NF-2), $NF}')
	#echo  "cpu1分钟负荷 " $a/${cpucore_num}   >>  $logfile
        awk 'BEGIN{printf "cpu1分钟负荷 %.0f%%\n",('$a/${cpucore_num}')*100}'   >>  $logfile
        #echo  "cpu5分钟负荷 " $b   >>  $logfile
        awk 'BEGIN{printf "cpu5分钟负荷 %.0f%%\n",('$b/${cpucore_num}')*100}'  >>  $logfile
	#echo  "cpu15分钟负荷 " $c   >>  $logfile
       awk 'BEGIN{printf "cpu15分钟负荷 %.0f%%\n",('$c/${cpucore_num}')*100}'  >>  $logfile

  if [ `which sar|wc -l` -eq 1 ];then
        #io
        sar -dp 1 2|awk '{if ($0~/Average/)print $2,$NF}'|awk 'NR >1{print "主机-磁盘IO繁忙度:" $0"%"}' >> $logfile
  fi

echo "$ip"
if [ "$ip" != "192.168.80.85" ];then
	ssh   tomcat@192.168.80.85   "mkdir  -p /tmp/${sysname}.zd/OS"
  scp $logfile tomcat@192.168.80.85:/tmp/${sysname}.zd/OS
fi
