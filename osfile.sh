#!/bin/bash

# CPU
cpu_usage=$(top -bn 1 | awk '/Cpu\(s\):/ {print $2}')

# 内存
memory_usage=$(free -m | awk '/Mem:/ {print $3/$2 * 100.0}')

# 磁盘
disk_usage=$(df -h / | awk '/\// {print $5}' | cut -d'%' -f1)

# 端口
port_status=$(netstat -tuln)

# 应用
app_status=$(systemctl status your-app-name.service)

# 应用连接数
app_connections=$(netstat -anp | grep your-app-process-name | wc -l)

# 定时任务
cron_jobs=$(crontab -l)

# 网络连通性
network_connectivity=$(ping -c 4 google.com)

# 日志文件检查（示例：检查最近的错误日志）
recent_error_logs=$(grep "ERROR" /var/log/syslog | tail -n 5)

# 网络带宽
network_bandwidth=$(ifstat -i eth0 -q -b -n 1 1 | tail -n 2)

# 安全性检查（示例：检查SSH登录日志）
security_logs=$(grep "Failed password" /var/log/auth.log | tail -n 5)

# 数据库连接和性能（示例：MySQL）
db_connection=$(mysql -h db-hostname -u username -p"password" -e "SHOW STATUS")

# 查看系统负载
load_average=$(uptime)

# 网络安全检查（示例：检查防火墙规则）
firewall_rules=$(iptables -L)

# 查看用户登录情况
logged_in_users=$(who)

# 检查磁盘I/O性能
disk_io=$(iostat)

# 查看网络接口状态
network_interfaces=$(ifconfig)

# 检查系统更新（示例：Ubuntu）
system_updates=$(apt list --upgradable)


# 查看系统进程信息
processes_info=$(ps aux)

# 检查系统日志文件（示例：检查最近的错误日志）
error_logs=$(tail -n 20 /var/log/syslog | grep "ERROR")

# 查看系统启动时间
uptime_info=$(uptime -s)

# 检查Swap使用情况
swap_usage=$(free -m | awk '/Swap:/ {print $3/$2 * 100.0}')

# 查看系统时间同步状态
time_sync_status=$(timedatectl status)

# 检查系统时钟健康性（示例：ntpdate）
clock_health=$(ntpdate -q pool.ntp.org)

# 查看系统登录历史
login_history=$(last -n 10)

# 检查系统临时文件夹使用情况
tmp_usage=$(du -sh /tmp)

# 查看系统监听的网络服务
listening_services=$(netstat -tuln)

# 检查系统文件权限（示例：/etc/passwd）
file_permissions=$(ls -l /etc/passwd)

# 查看系统内核参数
kernel_parameters=$(sysctl -a)

# 检查系统负载趋势（示例：sar）
load_trend=$(sar -q 1 5)


# 查看系统用户信息
system_users=$(cat /etc/passwd)

# 检查系统进程限制
process_limits=$(ulimit -a)

# 查看系统路由表
routing_table=$(ip route)

# 检查系统打开文件数
open_files=$(lsof | wc -l)

# 查看系统DNS配置
dns_config=$(cat /etc/resolv.conf)

# 检查网络连通性（示例：访问多个重要服务器）
connectivity_test=$(ping -c 4 google.com && ping -c 4 example.com)

# 检查系统TCP连接状态
tcp_connections=$(ss -tuln)

# 查看系统硬件信息
hardware_info=$(lshw)

# 检查系统环境变量
environment_variables=$(env)

# 查看系统默认路由
default_route=$(ip route show default)

# 检查系统中的定时器
timers=$(systemctl list-timers)

# 查看系统中安装的软件包
installed_packages=$(dpkg -l)

# 检查系统CPU信息
cpu_info=$(lscpu)

# 查看系统TCP连接状态（IPv6）
tcp_connections_ipv6=$(ss -tuln6)

# 检查系统负载趋势（示例：sar）
load_trend=$(sar -q 1 5)

# 查看系统SSH配置
ssh_config=$(cat /etc/ssh/sshd_config)

# 检查系统邮件队列
mail_queue=$(mailq)

# 查看系统CPU温度（需要lm-sensors）
cpu_temperature=$(sensors)

# 检查系统NTP同步状态
ntp_status=$(ntpq -p)

# 查看系统GPU信息（需要nvidia-smi，仅适用于NVIDIA GPU）
gpu_info=$(nvidia-smi)

echo "TCP连接状态 (IPv6):\n$tcp_connections_ipv6"
echo "系统负载趋势:\n$load_trend"
echo "SSH配置:\n$ssh_config"
echo "邮件队列:\n$mail_queue"
echo "CPU温度:\n$cpu_temperature"
echo "NTP同步状态:\n$ntp_status"
echo "GPU信息:\n$gpu_info"
echo "系统TCP连接状态:\n$tcp_connections"
echo "系统硬件信息:\n$hardware_info"
echo "系统环境变量:\n$environment_variables"
echo "默认路由:\n$default_route"
echo "系统定时器:\n$timers"
echo "安装的软件包:\n$installed_packages"
echo "CPU信息:\n$cpu_info"
echo "系统用户信息:\n$system_users"
echo "系统进程限制:\n$process_limits"
echo "系统路由表:\n$routing_table"
echo "打开的文件数: $open_files"
echo "DNS配置:\n$dns_config"
echo "网络连通性测试:\n$connectivity_test"
echo "系统登录历史:\n$login_history"
echo "临时文件夹使用情况: $tmp_usage"
echo "监听的网络服务:\n$listening_services"
echo "文件权限:\n$file_permissions"
echo "系统内核参数:\n$kernel_parameters"
echo "系统负载趋势:\n$load_trend"
echo "进程信息:\n$processes_info"
echo "最近的错误日志:\n$error_logs"
echo "系统启动时间: $uptime_info"
echo "Swap使用率: $swap_usage%"
echo "时间同步状态:\n$time_sync_status"
echo "时钟健康性:\n$clock_health"
echo "系统负载:\n$load_average"
echo "防火墙规则:\n$firewall_rules"
echo "登录用户:\n$logged_in_users"
echo "磁盘I/O性能:\n$disk_io"
echo "网络接口状态:\n$network_interfaces"
echo "可更新的软件:\n$system_updates"
echo "CPU使用率: $cpu_usage%"
echo "内存使用率: $memory_usage%"
echo "磁盘使用率: $disk_usage%"
echo "开放端口状态:\n$port_status"
echo "应用状态:\n$app_status"
echo "应用连接数: $app_connections"
echo "定时任务:\n$cron_jobs"
echo "网络连通性:\n$network_connectivity"
echo "最近的错误日志:\n$recent_error_logs"
echo "网络带宽:\n$network_bandwidth"
echo "安全日志:\n$security_logs"
echo "数据库连接和性能:\n$db_connection"


# 保存巡检结果到日志文件
log_file="/tmp/log/server_inspection_$(date +'%Y%m%d%H%M%S').log"
{
  echo "服务器巡检报告 - $(date)"
  echo "-------------------------------------"
  echo "TCP连接状态 (IPv6):\n$tcp_connections_ipv6"
  echo "系统负载趋势:\n$load_trend"
  echo "SSH配置:\n$ssh_config"
  echo "邮件队列:\n$mail_queue"
  echo "CPU温度:\n$cpu_temperature"
  echo "NTP同步状态:\n$ntp_status"
  echo "GPU信息:\n$gpu_info"
  echo "系统TCP连接状态:\n$tcp_connections"
  echo "系统硬件信息:\n$hardware_info"
  echo "系统环境变量:\n$environment_variables"
  echo "默认路由:\n$default_route"
  echo "系统定时器:\n$timers"
  echo "安装的软件包:\n$installed_packages"
  echo "CPU信息:\n$cpu_info"
  echo "系统用户信息:\n$system_users"
  echo "系统进程限制:\n$process_limits"
  echo "系统路由表:\n$routing_table"
  echo "打开的文件数: $open_files"
  echo "DNS配置:\n$dns_config"
  echo "网络连通性测试:\n$connectivity_test"
  echo "系统登录历史:\n$login_history"
  echo "临时文件夹使用情况: $tmp_usage"
  echo "监听的网络服务:\n$listening_services"
  echo "文件权限:\n$file_permissions"
  echo "系统内核参数:\n$kernel_parameters"
  echo "系统负载趋势:\n$load_trend"
  echo "进程信息:\n$processes_info"
  echo "最近的错误日志:\n$error_logs"
  echo "系统启动时间: $uptime_info"
  echo "Swap使用率: $swap_usage%"
  echo "时间同步状态:\n$time_sync_status"
  echo "时钟健康性:\n$clock_health"
  echo "系统负载:\n$load_average"
  echo "防火墙规则:\n$firewall_rules"
  echo "登录用户:\n$logged_in_users"
  echo "磁盘I/O性能:\n$disk_io"
  echo "网络接口状态:\n$network_interfaces"
  echo "可更新的软件:\n$system_updates"
  echo "CPU使用率: $cpu_usage%"
  echo "内存使用率: $memory_usage%"
  echo "磁盘使用率: $disk_usage%"
  echo "开放端口状态:\n$port_status"
  echo "应用状态:\n$app_status"
  echo "应用连接数: $app_connections"
  echo "定时任务:\n$cron_jobs"
  echo "网络连通性:\n$network_connectivity"
  echo "最近的错误日志:\n$recent_error_logs"
  echo "网络带宽:\n$network_bandwidth"
  echo "安全日志:\n$security_logs"
  echo "数据库连接和性能:\n$db_connection"
} > "$log_file"

echo "巡检结果已保存至 $log_file"
