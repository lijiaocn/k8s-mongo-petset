#!/bin/bash

SERVICE_NAME="mongo-service"
REPLICAS=3
NAMESPACE="lijiaob"
CLUSTER_DOMAIN="cluster.local"
CAPACITY="1Gi"
VERSION="latest"
MONGODB_DEF_USER="admin"
MONGODB_DEF_PWD="admin"

DELETE_EXSITING_DATA="yes"
MONGODB_HIDDEN_USER="forbiddenchangesystem"
MONGODB_HIDDEN_PWD="123456"

SECRET=`openssl rand -base64 756 |base64`

TEMPLATE=""

select t in `ls *template.yaml`;do
	if [[ $t != "" ]];then
		TEMPLATE=$t
		break;
	fi
done

RESULTFILE=$NAMESPACE.$SERVICE_NAME.yaml
if [[ -e $RESULTFILE ]];then
	mv -f $RESULTFILE $RESULTFILE.old
fi

if [[ $TEMPLATE == mongo-petset-persistent.template.yaml ]];then
	for (( i=$REPLICAS; i--; i>0 ));do
		echo "rbd create --size 1000 tenx-pool/$NAMESPACE-$SERVICE_NAME-$i"
		cat >>$RESULTFILE <<EOF
---
apiVersion: v1
kind: PersistentVolume
metadata:
  annotations:
    pv.kubernetes.io/bound-by-controller: "yes"
  labels:
    namespace: {{NAMESPACE}}
  name: {{NAMESPACE}}-{{SERVICE_NAME}}-$i
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: {{CAPACITY}}
  rbd:
    fsType: ext4
    image: {{NAMESPACE}}-{{SERVICE_NAME}}-$i
    keyring: /etc/ceph/ceph.client.admin.keyring
    monitors:
    - 10.39.0.114:6789
    - 10.39.0.115:6789
    - 10.39.0.116:6789
    pool: tenx-pool
    user: admin
EOF
	done
fi

cat $TEMPLATE >>$RESULTFILE

sed -i "" -e "s/{{SERVICE_NAME}}/$SERVICE_NAME/g"     $RESULTFILE
sed -i "" -e "s/{{REPLICAS}}/$REPLICAS/g"             $RESULTFILE
sed -i "" -e "s/{{NAMESPACE}}/$NAMESPACE/g"           $RESULTFILE
sed -i "" -e "s/{{CLUSTER_DOMAIN}}/$CLUSTER_DOMAIN/g" $RESULTFILE
sed -i "" -e "s/{{CAPACITY}}/$CAPACITY/g"             $RESULTFILE
sed -i "" -e "s/{{VERSION}}/$VERSION/g"               $RESULTFILE
sed -i "" -e "s/{{MONGODB_DEF_USER}}/$MONGODB_DEF_USER/g"   $RESULTFILE
sed -i "" -e "s/{{MONGODB_DEF_PWD}}/$MONGODB_DEF_PWD/g"     $RESULTFILE
sed -i "" -e "s/{{MONGODB_HIDDEN_USER}}/$MONGODB_HIDDEN_USER/g"   $RESULTFILE
sed -i "" -e "s/{{MONGODB_HIDDEN_PWD}}/$MONGODB_HIDDEN_PWD/g"     $RESULTFILE
sed -i "" -e "s/{{DELETE_EXSITING_DATA}}/$DELETE_EXSITING_DATA/g" $RESULTFILE
sed -i "" -e "s#{{SECRET}}#$SECRET#g" $RESULTFILE
