#!/bin/bash

execshell(){
#提权用户
upuser=''
[[ $upuser == '' ]]  ||  upuser_Method="sudo -u $upuser"
sys='xxx'
#redis参数
redis_conf=$1
redis_cli='/usr/local/xxx/redis/bin/redis-cli'

redis_port=$(grep 'port'  $redis_conf  | grep -v '#' |  awk '{print $NF}' )
redis_pid=$(grep 'pidfile'   $redis_conf     | grep -v '#' |  awk '{print $NF}' | xargs cat)
redis_pw=$(grep 'requirepass'   $redis_conf     | grep -v '#' |  awk '{print $NF}')
redis_bind_ip=$(grep -i 'bind'  $redis_conf  | grep -v '#' |  awk '{print $NF}' )
#存放目录
ip=$(ifconfig  | grep '10.252' | awk -F:   '{print $2}' | awk '{print $1}')
times=$(date "+%Y%m%d%H%M")
save_path="/tmp/health/redis"
mkdir -p   $save_path
file_path=$save_path/${ip}_${redis_port}.txt


#目标IP
target_ip='tomcat@192.168.80.85'


#redis服务端口
value=$(netstat  -nultp  2> /dev/null |grep  $redis_port  |grep  LISTEN | wc -l)
echo redis服务端口 $value > $file_path

#redis服务状态
value=$(ps aux  | grep -v 'grep' | grep $redis_pid  | awk  '$8!~/[zxZX]/{print }' | wc -l)
echo redis服务状态  $value >> $file_path


#阻塞客户端连接数
value=$($upuser_Method $redis_cli  -h $redis_bind_ip -p $redis_port -a '1qaz@WSX3edc$RFV'   info | grep blocked_clients | awk -F ":" '{print $2}')
echo 阻塞客户端连接数  $value >> $file_path

#redis当前内存使用率
value=$(ps -eo pid,%mem   |   grep $redis_pid | awk '{print $NF}')
echo redis当前内存使用率  ${value}% >> $file_path


#因连接限制而被拒绝连接数
value=$($upuser_Method $redis_cli  -h $redis_bind_ip -p $redis_port -a '1qaz@WSX3edc$RFV'   info | grep rejected_connections | awk -F ":" '{print $2}')
echo 因连接限制而被拒绝连接数  $value >> $file_path

#因内存限制而被拒绝连接数
value=$($upuser_Method $redis_cli  -h $redis_bind_ip -p $redis_port -a '1qaz@WSX3edc$RFV'   info | grep evicted_keys | awk -F ":" '{print $2}')
echo 因内存限制而被拒绝连接数  $value >> $file_path

#内存碎片  
value=$($upuser_Method $redis_cli  -h $redis_bind_ip -p $redis_port -a '1qaz@WSX3edc$RFV'   info  | grep  mem_fragmentation_ratio  | awk -F ":" '{print $2}' )
#value=$(echo  $($upuser_Method $redis_cli  -h 127.0.0.1 -p $redis_port -a '1qaz@WSX3edc$RFV'   info | grep keyspace_misses | awk -F ":" '{print $2}')  $($upuser_Method $redis_cli  -h 127.0.0.1 -p $redis_port -a '1qaz@WSX3edc$RFV'   info | grep keyspace_hits | awk -F ":" '{print $2}') |  awk '{print $1/($1+$2)*100}')
echo "内存碎片率"  ${value} >> $file_path


ssh    $target_ip    "mkdir -p /tmp/${sys}.zd/redis"
scp     $file_path   $target_ip:/tmp/${sys}.zd/redis/
}

execshell   /usr/local/xxxx/redis/etc/*redis.conf
