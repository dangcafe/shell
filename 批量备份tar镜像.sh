#!/bin/bash
#列出所有 Docker 镜像并导出为 tar 文件
docker images --format "{{.Repository}}:{{.Tag}}" | while read image

do

    # 去除镜像名称中的斜杠

    image_name=$(echo "$image" | tr -d ':/\')
    echo "Exporting $image..."
    docker save -o "${image_name}.tar" "$image"
    echo "$image exported as ${image_name}.tar."
done
echo "All images exported."
