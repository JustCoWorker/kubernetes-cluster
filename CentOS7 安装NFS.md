### CentOS7 安装NFS

##### 下载软件

```sh
yum install -y nfs-utils
```

##### 新建挂在文件夹

```sh
mkdir -p /var/nfs/k8s/harbor/registry
mkdir -p /var/nfs/k8s/harbor/chartmuseum
mkdir -p /var/nfs/k8s/harbor/jobservice
mkdir -p /var/nfs/k8s/harbor/database
mkdir -p /var/nfs/k8s/harbor/redis
```

##### 修改文件夹权限

```sh
chmod a+rw /var/nfs/k8s
```

##### 配置NFS服务目录

vi /etc/exports

```shell
/var/nfs/k8s  *(rw,sync,no_subtree_check,no_root_squash)
```

##### rpcbind和nfs做开机启动

```sh
systemctl enable rpcbind.service
systemctl enable nfs-server.service
```

##### 启动服务

```sh
systemctl start rpcbind.service
systemctl start nfs-server.service
```

##### 查看共享状态

```sh
showmount -e 

showmount -e 172.17.8.103
```
