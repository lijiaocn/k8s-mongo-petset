---
layout: default
title: README
author: lijiaocn
createdate: 2017/06/19 21:43:33
changedate: 2017/06/21 11:18:45
categories:
tags:
keywords:
description: 

---

* auto-gen TOC:
{:toc}

## 创建image:  mongo-init 

mong-init用于初始化mongo账号。

进入目录mongo-init，在Makefile中填入你自己的registry地址和account后，构建镜像:

	cd ./mongo-init
	make mongo-init

也可以修改用docker命令，直接构建，只要与后面的yaml文件中填入的镜像对应即可。

这里使用的是:

	harbor=example.lijiaocn.com
	account=lijiaocn


## 创建image:  mongo-k8s-sidecar

[mong-k8s-sidecar](https://github.com/lijiaocn/mongo-k8s-sidecar)用来监测mongod列表，进行RS设置。

	git clone https://github.com/lijiaocn/mongo-k8s-sidecar.git
	cd ./mongo-k8s-sidecar
	docker build -t  example.lijiaocn.com/lijiaocn/mong-k8s-sidecar:latest .

## 生成petset

到mongo-petset中生成yaml:

	cd ./mongo-petset
	./create.sh

mongo-petset中已经给出了两个模版，可以根据需要自行修改。

注意这里面使用的镜像替换成你自己的镜像地址:

	image: example.lijiaocn.com/lijiaocn/mongo:latest
	image: example.lijiaocn.com/lijiaocn/mongo-k8s-sidecar:latest
