#!/bin/bash

#


dir="/home/software/images_backup/`date +'%Y%m%d%H'`/conf"

dir2="/home/software/images_backup/`date +'%Y%m%d%H'`/images"

[ -d ${dir} ] || mkdir -p ${dir}

[ -d ${dir2} ] || mkdir -p ${dir2}

#backup images

kubectl get deploy -o wide --all-namespaces >${dir2}/images_$(date '+%Y%m%d%H%M%S').txt

kubectl get po -o wide --all-namespaces >${dir2}/pod_$(date '+%Y%m%d%H%M%S').txt

#backup deploy/cm/svc/pv/pvc

kubectl get deploy --all-namespaces|awk '{print $1,$2}'|grep -v NAME|while read ns deploy

do

  kubectl get deploy $deploy -o yaml -n $ns > ${dir}/deploy--$ns--$deploy.yaml

done



#cm

kubectl get cm --all-namespaces |awk '{print $1,$2}'|grep -vE "NAME|fst-manage"|while read ns cm

do

  kubectl get cm  $cm -n $ns -o yaml > ${dir}/cm--$ns--$cm.yaml

done



#cm

#cd /home/software/tool/

#kubectl get cm --all-namespaces |awk '{print $1,$2}'|grep -vE "NAME|fst-manage"|while read ns cm

#do

#/usr/bin/expect images_backup.exp  $cm  $ns  > ${dir}/cm-describe--$ns--$cm.yaml

#done



#svc

kubectl get svc --all-namespaces  |awk '{print $1,$2}'|grep -v NAME|while read ns svc

do

  kubectl get svc $svc -n $ns  -o yaml > ${dir}/svc--$ns--$svc.yaml

done



#pv

#kubectl get pv |awk '{print $1}'|grep -v "NAME"|while read pv

#do

#kubectl get pv  $pv  -o yaml > ${dir}/pv-$pv.yaml

#done



#pvc

kubectl get pvc --all-namespaces|awk '{print $1,$2}'|grep -v NAME|while read ns pvc

do

 kubectl get pvc  -n $ns $pvc -o yaml > ${dir}/pvc--$ns--$pvc.yaml

done
