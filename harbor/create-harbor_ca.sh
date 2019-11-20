#!/bin/bash
# Deploy CFSSL
echo "Deploy CFSSL"

wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
chmod +x cfssl_linux-amd64
mv cfssl_linux-amd64 /usr/local/bin/cfssl

wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssljson_linux-amd64
mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl-certinfo_linux-amd64
mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo

export PATH=/usr/local/bin:$PATH

cd /vagrant/pki
cp /vagrant/harbor/registry.jaychang.cn-csr.json /vagrant/pki/

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes registry.jaychang.cn-csr.json | cfssljson -bare harbor
ls harbor*

tr -d '\r\n' < ca.pem |base64

tr -d '\r\n' < ./harbor.pem |base64

 tr -d '\r\n' < ./harbor-key.pem |base64