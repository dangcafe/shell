#/usr/bin/env bash

#****管理系统一键诊断


server_name="Server"
jmap="/smp/amp/jdk/bin/jmap"
jstat="/smp/amp/jdk/bin/jstat"
jstack="/smp/amp/jdk/bin/jstack"

ip=$(ip a | grep -E "192.168.80" | awk -F " |/" '{print $6}')


  if [[ $ip == "192.168.80.75" || $ip == "192.168.80.76" || $ip == "192.168.80.77" || $ip == "192.168.80.107" ]];then
    collect_log="/tmp/${ip}_7011.txt"
    port="7011"
    app_log="/u01/bea/user_projects/domains/cms_domain/logs/cmsserver.log"
  elif  [ "$ip" == "192.168.80.107" ];then
    collect_log="/tmp/${ip}_7011.txt"
	app_log="/u01/bea/user_projects/domains/cms_domain/servers/CmsServer/logs/CmsServer.log"
	port="7011"
  else
    ip=$(ip a | grep -E "10.252.114.198" | awk -F " |/" '{print $6}')  
	jmap1="/u01/jdk1.5.0_14/bin/jmap"
	jstat1="/u01/jdk1.5.0_14/bin/jstat"
	jstack1="/u01/jdk1.5.0_14/bin/jstack"
    collect_log="/tmp/${ip}_7011.txt"
    port="7011"
    app_log="/u01/bea923/user_projects/domains/cms_domain/servers/CmsServer/logs/CmsServer.log"
  fi

echo $collect_log

sudo -u root touch $collect_log && sudo -u root chmod 777 $collect_log

  collect_info(){

    PID=$(ps -ef | grep "$server_name" | grep -v grep | awk '{print $2}')
	#echo $ip
	if [ "$ip" == "192.168.80" ];then
	echo -e "JVM堆内存使用率 $(echo "scale=2;$(echo "scale=2;$(sudo -u root $jmap1 -histo $PID | grep -w Total | awk '{print $3}') / 1048576"|bc) * 100 / $(ps -ef | grep "$server_name" | grep -v grep | grep -Eio "\-Xmx[0-9]+m" | grep -Eo "[0-9]+")"|bc)%"
    #echo -e "JVM堆内存使用率 56.7%"
	#else
	#echo -e "JVM堆内存使用率 54.7%" 
	fi
	
	#JVM堆内存使用率检测
    #echo -e "JVM堆内存使用率 $(echo "scale=2;$(echo "scale=2;$(sudo -u root $jmap -histo $PID | grep -w Total | awk '{print $3}') / 1048576"|bc) * 100 / $(ps -ef | grep "$server_name" | grep -v grep | grep -Eio "\-Xmx[0-9]+m" | grep -Eo "[0-9]+")"|bc)%"
	
    #Weblogic进程检测
          echo -e "进程状态 $(ps -ef | grep -v grep | grep "$server_name" &> /dev/null && echo "1" || echo "0")"

    #Weblogic端口检测
          echo -e "进程端口状态 $(sudo -u root netstat -anptl | grep $PID | grep LISTEN | grep -w $port &> /dev/null && echo "1" || echo "0")"

    #Weblogic FGC频次检测 + 次数检查 + 时间检查 + 新生代使用率 + 老年代使用率
    if [ `echo $ip | grep -c "192.168.80."` -ne 0 ];then
#    if [ `echo $host | grep -i "*.sgs*"` -eq 0 ];then
            echo -e "FGC频次是否异常(1Min) $(sudo -u root $jstat -gcutil $PID 12000 5 2> /dev/null | sed -n "2p;\$p" | awk '{if(NR==1){a=$9}else{b=$9}}END{if(b>a){print "0"}else{print "1"};{print "FGC总次数",$9};{print "FGC总用时(s)",$10};{print "JVM年轻代内存使用率",$3"%"};{print "JVM年老代内存使用率",$4"%"}}')"
    else
      echo -e "FGC频次是否异常(1Min) $(sudo -u root $jstat -gcutil $PID 12000 5 2> /dev/null | sed -n "2p;\$p" | awk '{if(NR==1){a=$8}else{b=$8}}END{if(b>a){print "0"}else{print "1"};{print "FGC总次数",$8};{print "FGC总用时(s)",$9};{print "JVM年轻代内存使用率",$3"%"};{print "JVM年老代内存使用率",$4"%"}}')"
    fi

    #Weblogic活动线程数 + 占比检测
          echo -e "活动线程数 $(sudo -u root ps -T -p $PID | grep -v grep | wc -l)\n活动线程数占比 $(echo "scale=2;$(sudo -u root ps -T -p $PID | grep -v grep | wc -l) * 100 / 500"|bc)%"

    #Weblogic线程状态
    Thread_info=$(sudo -u root $jstack $PID | grep "java.lang.Thread.State" | awk '{print $2}')
    for state in NEW RUNNABLE BLOCKED WAITING TIMED_WAITING TERMINATED
    do
      echo -e "线程状态($state) $(echo $Thread_info | grep -o $state | wc -l)"
    done

    #Weblogic JDBC连接池活动数占比检测
          echo -e "JDBC连接池活动数占比 $(echo "scale=2;$(sudo -u root netstat -anptl | grep $PID | grep "1521" | grep -c "ESTABLISHED") * 100 / 40"|bc)%"

    #Weblogic应用日志检测
    if [ `echo $ip | grep -c "192.168.80"` -eq 0 ];then
      logs_info=$(sudo -u root awk "," '$1 >="'"$(date -d '6 minutes ago' '+%F %H:%M:%S')"'" && $1 <= "'"$(date '+%F %H:%M:%S')"'"' $app_log)
    else
      logs_info=$(sudo -u root awk "|" '$1 >="'"$(date -d '6 minutes ago' '+<%F %H:%M:%S>')"'" && $1 <= "'"$(date '+<%F %H:%M:%S>')"'"' $app_log)
    fi

          for word in WARN ERROR OutOfMemory JDBCException IOException SocketException
          do
            echo -e "${word}异常日志 $(echo $logs_info | grep -oi $word | wc -l)"
          done
}

collect_info > $collect_log

