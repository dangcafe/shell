#/usr/bin/env bash

ip=$(ip a | grep -E "192.168.80.41|192.168.80.42" | awk -F " |/" '{print $6}')

#nginx参数
nginx_conf='/usr/local/nginx/conf/nginx.conf'
nginx_error_log='/usr/local/nginx/nginx/logs/error.log'
nginx_access_log='/usr/local/nginx/logs/access.log'
dir_name='/usr/local/nginx/conf/nginx.conf'
dir_old='/tmp/fi.txt'
nowdata='/usr/local/nginx/conf/nginx.conf'
befdata='/tmp/nginx.conf-b'

sysname="xxxx"

path=/tmp/nginx
if [ ! -d $path ];then
  mkdir $path
fi
file_path=$path/${ip}_.txt
touch $file_path && chmod 777 $file_path

#目标IP
target_ip='tomcat@192.168.80.42.85'

#nginx_After_Response_Average_Time	后端请求访问响应时间
value=$(tail  -1000 $nginx_access_log  | awk  '{print $4}' | awk -F: '{a=a+$2}END{print a/1000}')
echo 后端请求访问响应时间 $value > $file_path

#Nginx服务状态
value=$(ps -ef | grep 'nginx: master' | grep -v grep  | wc -l)
echo Nginx服务状态 $value >> $file_path

#Nginx服务端口
value=$(sudo -u root grep listen   $nginx_conf  | grep -v '#' | awk '{print $2}' | sort -u | wc -l)
[ $value == $(netstat -nultp 2> /dev/null| grep nginx | wc -l) ]  && value=1
echo Nginx服务端口 $value >> $file_path

#nginx_Log_Exception	日志exception关键字
value=$(sudo -u root tail  -1000 $nginx_error_log | egrep -i  'execption' | wc -l)
echo 日志exception关键字 $value >> $file_path

#nginx_Log_Error	日志error关键字	E掌通个性化，其他系统需要调整
value=$(sudo -u root tail  -1000    $nginx_error_log  | egrep -i  'error' | egrep -iv 'cms_res|/gmccservice/queryAllGroup'  | egrep $(date  "+%Y/%m/%d") | wc -l)
echo 日志error关键字 $value >> $file_path

#nginx配置文件权限修改检测
old_p=$(sudo -u root cat ${dir_old} | awk '{print $1}')
new_p=$(sudo -u root ls -l --time=ctime --full-time ${dir_name} | awk '{print $1}')
new_time=$(sudo -u root ls -l --time=ctime --full-time ${dir_name} | awk '{print $6" "$7}')
if [[ ${old_p} == ${new_p} ]];then
    echo "文件权限状态 1" >> $file_path
else
    echo "文件权限状态 0" >> $file_path
fi
sudo -u root ls -l --time=ctime --full-time ${dir_name} | awk '{print $1" "$6$7}' | sudo -u root tee /tmp/fi.txt >/dev/null
#nginx配置文件内容修改检测
nowdata='/usr/local/nginx/conf/nginx.conf'
befdata='/tmp/nginx.conf-b'
sudo -u root diff -u ${nowdata} ${befdata}
if [[ $? -eq 0 ]];then
    echo '文件内容状态 1' >> $file_path
else
    echo '文件内容状态 0' >> $file_path
fi

#nginx_Code_400	异常状态码400
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/400/{print}'  | wc -l)
echo 异常状态码400  $value >> $file_path

#nginx_Code_401	异常状态码401
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/401/{print}'  | wc -l)
echo 异常状态码401  $value >> $file_path

#nginx_Code_402	异常状态码403
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/402/{print}'  | wc -l)
echo 异常状态码402 $value >> $file_path

#nginx_Code_403	异常状态码403
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/403/{print}'  | wc -l)
echo 异常状态码403 $value >> $file_path

#nginx_Code_404	异常状态码404
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/404/{print}'  | wc -l)
echo 异常状态码404 $value >> $file_path

#nginx_Code_405	异常状态码405
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/405/{print}'  | wc -l)
echo 异常状态码405 $value >> $file_path

#nginx_Code_500	异常状态码500
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/500/{print}'  | wc -l)
echo 异常状态码500 $value >> $file_path

#nginx_Code_501	异常状态码501
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/501/{print}'  | wc -l)
echo 异常状态码501 $value >> $file_path

#nginx_Code_502	异常状态码502
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/502/{print}'  | wc -l)
echo 异常状态码502 $value >> $file_path

#nginx_Code_503	异常状态码503
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/503/{print}'  | wc -l)
echo 异常状态码503 $value >> $file_path

#nginx_Code_504	异常状态码504
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/504/{print}'  | wc -l)
echo 异常状态码504 $value >> $file_path

#nginx_Code_505	异常状态码505
value=$(sudo -u root tail  -1000 $nginx_access_log | awk '$NF~/505/{print}'  | wc -l)
echo 异常状态码505 $value >> $file_path

sleep 5
ssh $target_ip    "mkdir -p /tmp/${sysname}.zd/nginx"
scp     $file_path   $target_ip:/tmp/${sysname}.zd/nginx/
