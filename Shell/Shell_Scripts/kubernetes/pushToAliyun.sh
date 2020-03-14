#!/bin/bash
# 下面的镜像应该去除"k8s.gcr.io/"的前缀，版本换成kubeadm config images list命令获取到的版本
images=(
    kube-apiserver:v1.14.0
    kube-controller-manager:v1.14.0
    kube-scheduler:v1.14.0
    kube-proxy:v1.14.0
    pause:3.1
    etcd:3.3.10
    coredns:1.3.1
)
docker login --username=1689991551@qq.com registry.cn-shenzhen.aliyuncs.com

for imageName in ${images[@]} ; do
    docker tag k8s.gcr.io/$imageName registry.cn-shenzhen.aliyuncs.com/jzh/$imageName 
    docker push registry.cn-shenzhen.aliyuncs.com/jzh/$imageName
done
