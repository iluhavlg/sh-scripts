#!/bin/bash

K8S_VERSION=1.20.4-00
# List all available versions
# curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'

# Install kubelet, kubeadm and kubectl
sudo apt update
sudo apt -y install curl apt-transport-https gnupg gnupg1 gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update 
sudo apt -y install vim git curl wget htop
sudo apt-get install -qy kubelet=$K8S_VERSION kubectl=$K8S_VERSION kubeadm=$K8S_VERSION
sudo apt-mark hold kubelet kubeadm kubectl
kubectl version --client && kubeadm version

# disable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 
# можно руками закоментировать swap в /etc/fstab
# выключить swap в текущей сессии, действует до перезагрузки
sudo swapoff -a

# настройка sysctl
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# Installing Docker runtime
sudo apt-get update
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get install -y lvm2
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common net-tools
# For Ubuntu
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# For Debian
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo apt-get update
#sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# For Ubuntu
#sudo apt-get update && sudo apt-get install -y containerd.io=1.2.13-2 docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)

# For Debian
sudo apt-get update && sudo apt-get install -y containerd.io=1.2.13-2 docker-ce=5:19.03.11~3-0~debian-$(lsb_release -cs) docker-ce-cli=5:19.03.11~3-0~debian-$(lsb_release -cs)

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
sudo systemctl status docker
