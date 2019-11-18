#Helm安装Harbor到  Kubernetes 集群

#####CentOS 安装 helm

```shell
vagrant  ssh node3
sudo -i
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.8.2-linux-amd64.tar.gz

tar -zxvf helm-v2.8.2-linux-amd64.tar.gz 
cd linux-amd64/
cp helm /usr/bin

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init -i jimmysong/kubernetes-helm-tiller:v2.8.2
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

helm version

```

##### 部署harbor

```shell
#每个节点上拉去镜像文件

docker pull goharbor/chartmuseum-photon:v0.9.0-v1.9.2
docker pull goharbor/clair-photon:v2.0.9-v1.9.2
docker pull goharbor/harbor-core:v1.9.2
docker pull goharbor/harbor-jobservice:v1.9.2
docker pull goharbor/notary-server-photon:v0.6.1-v1.9.2
docker pull goharbor/notary-signer-photon:v0.6.1-v1.9.2
docker pull goharbor/harbor-portal:v1.9.2
docker pull goharbor/harbor-registryctl:v1.9.2
docker pull goharbor/registry-photon:v2.7.1-patch-2819-2553-v1.9.2
docker pull busybox:latest
docker pull goharbor/harbor-db:v1.9.2
docker pull goharbor/redis-photon:v1.9.2


cd /vagrant/harbor

kubectl create namespace kube-ops

kubectl apply -f nfs-client.yaml -n kube-ops

kubectl apply -f nfs-client-sa.yaml -n kube-ops

kubectl apply -f harbor-secret.yaml -n kube-ops

kubectl apply -f harbor-pvc.yaml -n kube-ops

cd /vagrant/harbor/harbor-helm-1.1.5/
helm install --name my-release . --namespace kube-ops -f values.yaml


helm delete my-release --purge



```

##### 

