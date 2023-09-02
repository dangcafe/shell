#!/bin/bash


# 检查入参是否正确
if [ $# -ne 2 ]; then
    echo "Usage: $0 <tomcat_home> <tomcat_port>"
    exit 1
fi

# 设置Tomcat目录和日志文件路径
TOMCAT_HOME=$1
TOMCAT_PORT=$2
LOG_FILE=$TOMCAT_HOME/logs/catalina.out


# 检查Tomcat是否已经停止
function check_tomcat_stop() {
  if [ ! -z "$(ps -ef | grep $TOMCAT_HOME | grep -v grep)" ]
  then
    echo "Tomcat is still running."
    exit 1
  fi
}

# 检查Tomcat是否已经启动
function check_tomcat_start() {
  if [ -z "$(ps -ef | grep $TOMCAT_HOME | grep -v grep)" ]
  then
    echo "Tomcat failed to start."
    #tail -n 100 $LOG_FILE
    exit 1
  fi
}

# 通过Tomcat端口是否是listen状态，判断Tomcat是否启动完成
function check_tomcat_port() {
for ((i=1;i<=20;i++));
do
    netstat -anlt|grep $TOMCAT_PORT |grep LISTEN > /dev/null
    if [ $? -eq 0 ]; then
        break
		
    fi
    sleep 10
done 

}

# 停止Tomcat
function stop_tomcat() {
  check_tomcat_stop
  #$TOMCAT_HOME/bin/shutdown.sh 
  
  sleep 5
  check_tomcat_stop
}

# 启动Tomcat
function start_tomcat() {
  check_tomcat_start
  $TOMCAT_HOME/bin/startup.sh
  sleep 10
  check_tomcat_start
}

# 重启Tomcat
function restart_tomcat() {
  stop_tomcat
  start_tomcat
}

# 执行重启操作
restart_tomcat
