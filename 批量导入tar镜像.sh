#!/bin/bash
#获取当前目录下的所有 tar 文件
tar_files=$(ls *.tar)
#循环遍历所有 tar 文件并导入为 Docker 镜像
for tar_file in $tar_files
do
    echo "Importing $tar_file..."
    docker load -i "$tar_file"
    echo "$tar_file imported."
done
echo "All images imported."
