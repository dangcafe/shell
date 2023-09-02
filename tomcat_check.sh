#/usr/bin/env bash
#固定参数
ip=$(ip a | grep -E "10.243" | awk -F " |/" '{print $6}')
upuser="admin"                                    # 程序账号
jdk_bin="/usr/local/jdk1.8.0_181/bin"
jmap="${jdk_bin}/jmap"             # jmap命令路径   
jstat="${jdk_bin}/jstat"           # jstat命令路径  
jstack="${jdk_bin}/jstack"         # jstack命令路径  
sysname="XXXX"

#________________________________脚本主体___________________________________________________


  collect_info(){
    [ $2 -gt 1024 ]   || upuser="root"
  	mkdir -p  /tmp/${sysname}/tomcat
  	touch $5 && chmod 777 $5

    PID=$(ps -ef | grep "$1" | grep -v grep | awk '{print $2}')


    #Tomcat进程检测
	  echo -e "进程状态 $(ps -ef | grep -v grep | grep "$1" &> /dev/null && echo "1" || echo "0")"  >  $5

    #Tomcat端口检测
	  echo -e "进程端口状态 $(sudo -u $upuser netstat -anptl | grep $PID | grep LISTEN | grep -w $2 &> /dev/null && echo "1" || echo "0")"  >>   $5


    #Tomcat线程数 sudo -u $upuser ps  -Tl  $PID | wc -l
	  echo -e "线程数 $(sudo -u $upuser ps  -Tl  $PID | wc -l)"   >>   $5

    #Tomcat线程状态
    #Thread_info=$(sudo -u $upuser $jstack $PID | grep "java.lang.Thread.State" | awk '{print $2}')
    #for state in BLOCKED WAITING TIMED_WAITING DEADLOCK
    #do
    #  echo -e "线程状态($state) $(echo $Thread_info | grep -o $state | wc -l)"   >>   $5
    #done

    #Tomcat JDBC连接数
	  echo -e "JDBC连接数 $(sudo -u $upuser netstat -anptl | grep $PID | grep "3306" | grep -c "ESTABLISHED" )  "   >>   $5

    #Tomcat应用日志检测
    sudo -u $upuser awk  "/$(date -d "6 minutes ago" "+%H:%M")/,/$(date "+%H:%M")/"  $3  >  /tmp/${sysname}/tomcat/logs_info.txt
	for word in WARN ERROR OutOfMemory JDBCException IOException SocketException
	do
	    echo -e "${word}异常日志 $( grep -oi $word /tmp/${sysname}/tomcat/logs_info.txt | wc -l)"  >>   $5
	done

    #Tomcat访问日志检测
	
    sudo -u $upuser awk  "/$(date -d "6 minutes ago" "+%H:%M")/,/$(date "+%H:%M")/" $4 2> /dev/null | grep -Ewo  " [45]0[0-9] "   > /tmp/${sysname}/tomcat/code_info.txt
    for code in 40{0..5} 50{0..5}
    do
	    echo -e "异常状态码${code} $(grep -o $code /tmp/${sysname}/tomcat/code_info.txt  | wc -l)"  >>   $5
	done

	echo $5
	}
	
