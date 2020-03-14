#!/bin/bash
# This scripts used by pull Image from Aliyun to deploy Kubernetesv1.17.3
#
# Login Aliyun Repo
docker login --username=1689991551@qq.com registry.cn-shenzhen.aliyuncs.com

# Image list
IMAGE_LIST=(
	kube-apiserver:v1.17.3
	kube-controller-manager:v1.17.3
	kube-scheduler:v1.17.3
	kube-proxy:v1.17.3
	coredns:1.6.5
	etcd:3.4.3-0
	flannel:v0.11.0-amd64
	pause:3.1
	nginx-ingress-controller:0.30.0
)

# Pull Image
for imageIndex in ${!IMAGE_LIST[@]}
do
	docker pull docker pull registry.cn-shenzhen.aliyuncs.com/jzh/${IMAGE_LIST[imageIndex]}
done

# Tag k8s.gcr.io image
GCR_IMAGE=(
	kube-apiserver:v1.17.3
        kube-controller-manager:v1.17.3
        kube-scheduler:v1.17.3
        kube-proxy:v1.17.3
        coredns:1.6.5
        etcd:3.4.3-0
        pause:3.1
)
for imageIndex in ${!GCR_IMAGE[@]}
do
	docker tag registry.cn-shenzhen.aliyuncs.com/jzh/${GCR_IMAGE[imageIndex]} k8s.gcr.io/${GCR_IMAGE[imageIndex]}
done
# Tag other iamge
docker tag registry.cn-shenzhen.aliyuncs.com/jzh/flannel:v0.11.0-amd64 quay.io/coreos/flannel:v0.11.0-amd64
docker tag registry.cn-shenzhen.aliyuncs.com/jzh/nginx-ingress-controller:0.30.0 quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
