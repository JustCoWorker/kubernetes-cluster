#Mac OS创建kubernetes集群

###一、 环境准备

##### 软件下载

#####  1.Vagrant

   https://www.vagrantup.com

##### 2.VirtualBox 

  https://www.virtualbox.org/wiki/Downloads

#####  3.kubernetes-server-linux-amd64.tar.gz   

https://storage.googleapis.com/kubernetes-release/release/v1.15.0/kubernetes-server-linux-amd64.tar.gz

#####4.kubernetes-client-linux-amd64.tar.gz

https://storage.googleapis.com/kubernetes-release/release/v1.15.0/kubernetes-client-linux-amd64.tar.gz

##### 5.CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box

http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box

```bash
vagrant box add CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box --name centos/7
```

##### 6.安装软件

macOS中 安装  Vagrant 和 VirtualBox

### 二、Kubernetes集群创建

我们使用Vagrant和Virtualbox安装包含3个节点的kubernetes集群，其中master节点同时作为node节点。

```bash
git clone https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster.git
cd kubernetes-vagrant-centos-cluster
```

##### 1.手动添加centos/7 box

```bash
wget -c http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box
vagrant box add CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box --name centos/7
```

##### 2.下载kubernetes的压缩包到`kubenetes-vagrant-centos-cluster`目录下

- kubernetes-client-linux-amd64.tar.gz
- kubernetes-server-linux-amd64.tar.gz

##### 3.在kubernetes-vagrant-centos-cluster目录下执行 vagrant up 创建集群

```bash
vagrant up
```

##### 4.集群说明

| IP           | 主机名 | 组件                                                         |
| ------------ | ------ | ------------------------------------------------------------ |
| 172.17.8.101 | node1  | kube-apiserver、kube-controller-manager、kube-scheduler、etcd、kubelet、docker、flannel、dashboard |
| 172.17.8.102 | node2  | kubelet、docker、flannel、traefik                            |
| 172.17.8.103 | node3  | kubelet、docker、flannel                                     |

**注意**：以上的IP、主机名和组件都是固定在这些节点的，即使销毁后下次使用vagrant重建依然保持不变。

容器IP范围：172.33.0.0/30

Kubernetes service IP范围：10.254.0.0/16

### 三、集群访问

将`conf/admin.kubeconfig`文件放到`~/.kube/config`目录下即可在本地使用`kubectl`命令操作集群。

在kubernetes-vagrant-centos-cluster目录下执行

```bash
mkdir -p ~/.kube
cp conf/admin.kubeconfig ~/.kube/config
```

### 四、虚拟机管理

#####挂起

将当前的虚拟机挂起，以便下次恢复。

```bash
vagrant suspend
```

##### 恢复

恢复虚拟机的上次状态。

```bash
vagrant resume
```

注意：我们每次挂起虚拟机后再重新启动它们的时候，看到的虚拟机中的时间依然是挂载时候的时间，这样将导致监控查看起来比较麻烦。因此请考虑先停机再重新启动虚拟机。

#####重启

停机后重启启动。

```bash
vagrant halt
vagrant up
# login to node1
vagrant ssh node1
# run the prosivision scripts
/vagrant/hack/k8s-init.sh
exit
# login to node2
vagrant ssh node2
# run the prosivision scripts
/vagrant/hack/k8s-init.sh
exit
# login to node3
vagrant ssh node3
# run the prosivision scripts
/vagrant/hack/k8s-init.sh
sudo -i
cd /vagrant/hack
./deploy-base-services.sh
exit
```

现在你已经拥有一个完整的基础的kubernetes运行环境，在该repo的根目录下执行下面的命令可以获取kubernetes dahsboard的admin用户的token。

```bash
sudo -i
/vagrant/hack/get-dashboard-token.sh
```

根据提示登录即可。

##### 清理

清理虚拟机。

```bash
vagrant destroy
rm -rf .vagrant
```



