#/usr/bin/env bash

ip=$(ip a | grep -E "192.168.80" | awk -F " |/" '{print $6}')
jmap="/web/jdk1.8.0_73/bin/jmap"
jstat="/web/jdk1.8.0_73/bin/jstat"
jstack="/web/jdk1.8.0_73/bin/jstack"
sysname="xxxx"

path=/tmp/activemq
if [ ! -d $path ];then
  mkdir $path
fi

ip=$(ip a | grep -E "192.168.80" | awk -F " |/" '{print $6}')

collect_info(){
  PID=$(ps -ef|grep -v grep | grep "$server_name" | awk '{print $2}')

  #JVM堆内存使用率检测
  echo -e "JVM堆内存使用率 $(echo "scale=2;$(echo "scale=2;$(sudo -u web $jmap -histo $PID | grep -w Total | awk '{print $3}') / 1048576"|bc) * 100 / $(ps -ef | grep "$server_name" | grep -Eio "\-Xmx[0-9]+m" | grep -Eo "[0-9]+")"|bc)%"

  #Tomcat进程检测
  echo -e "进程状态 $(ps -ef|grep -v grep | grep "$server_name" &> /dev/null && echo "1" || echo "0")"

  #Tomcat端口检测
  echo -e "进程端口状态 $(sudo -u web netstat -anptl | grep $PID | grep LISTEN | grep -w $port &> /dev/null && echo "1" || echo "0")"

  #Tomcat FGC频次检测 + 次数检查 + 时间检查 + 新生代使用率 + 老年代使用率
  echo -e "FGC频次是否异常(1Min) $(sudo -u web $jstat -gcutil $PID 12000 5 2> /dev/null | sed -n "2p;\$p" | awk '{if(NR==1){a=$8}else{b=$8}}END{if(b>a){print "0"}else{print "1"};{print "FGC总次数",$8};{print "FGC总用时(s)",$9};{print "JVM年轻代内存使用率",$3"%"};{print "JVM年老代内存使用率",$4"%"}}')"
echo -e "FGC频次是否异常(1Min) $(sudo -u web $jstat -gcutil $PID 12000 5 2> /dev/null | sed -n "2p;\$p" | awk '{if(NR==1){a=$9}else{b=$9}}END{if(b>a){print "0"}else{print "1"};{print "FGC总次数",$9};{print "FGC总用时(s)",$10};{print "JVM年轻代内存使用率",$3"%"};{print "JVM年老代内存使用率",$4"%"}}')"
#      if [ `echo $ip | grep -c "10.253.176"` -ne 0 ];then
#        echo -e "FGC频次是否异常(1Min) $(sudo -u web $jstat -gcutil $PID 12000 5 2> /dev/null | sed -n "2p;\$p" | awk '{if(NR==1){a=$9}else{b=$9}}END{if(b>a){print "0"}else{print "1"};{print "FGC总次数",$9};{print "FGC总用时(s)",$10};{print "JVM年轻代内存使用率",$3"%"};{print "JVM年老代内存使用率",$4"%"}}')"
#      else
#        echo -e "FGC频次是否异常(1Min) $(sudo -u web $jstat -gcutil $PID 12000 5 2> /dev/null | sed -n "2p;\$p" | awk '{if(NR==1){a=$8}else{b=$8}}END{if(b>a){print "0"}else{print "1"};{print "FGC总次数",$8};{print "FGC总用时(s)",$9};{print "JVM年轻代内存使用率",$3"%"};{print "JVM年老代内存使用率",$4"%"}}')"
#      fi
sleep 5
	ssh   tomcat@192.168.80.85   "mkdir  -p /tmp/${sysname}.zd/activemq"
	scp $collect_log tomcat@192.168.80.85:/tmp/${sysname}.zd/activemq && echo "File: '$collect_log' send to the directory of host 'XX' '/tmp/${sysname}.zd/activemq/'"
}


