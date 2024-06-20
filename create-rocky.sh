#!/bin/bash

echo "------ creating Rocky 8 ------"
rm -rf ./images/rocky8.qcow2
wget https://download.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2 -O ./images/rocky8.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/rocky8.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/rocky8.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/rocky8.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/rocky8.qcow2
cp ./config/rocky/getty-r8 ./config/rocky/getty@tty1.service
cp ./config/rocky/cloud-r8.cfg ./config/rocky/cloud.cfg
sudo virt-copy-in './config/rocky/getty@tty1.service' /lib/systemd/system/ -a ./images/rocky8.qcow2
sudo virt-copy-in './config/rocky/cloud.cfg' /etc/cloud/ -a ./images/rocky8.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/rocky8.qcow2
echo "------ disable kernel auto update ------"
sudo virt-customize --run-command "echo 'exclude=kernel*' >> /etc/yum.conf" -a ./images/rocky8.qcow2
sudo virt-sysprep -a ./images/rocky8.qcow2


echo "------ creating Rocky 9 ------"
rm -rf ./images/rocky9.qcow2
wget https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 -O ./images/rocky9.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/rocky9.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/rocky9.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/rocky9.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/rocky9.qcow2
cp ./config/rocky/getty-r9 ./config/rocky/getty@tty1.service
cp ./config/rocky/cloud-r9.cfg ./config/rocky/cloud.cfg
sudo virt-copy-in './config/rocky/getty@tty1.service' /lib/systemd/system/ -a ./images/rocky9.qcow2
sudo virt-copy-in './config/rocky/cloud.cfg' /etc/cloud/ -a ./images/rocky9.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/rocky9.qcow2
echo "------ disable kernel auto update ------"
sudo virt-customize --run-command "echo 'exclude=kernel*' >> /etc/yum.conf" -a ./images/rocky9.qcow2
sudo virt-sysprep -a ./images/rocky9.qcow2

echo "------ Done ------"
