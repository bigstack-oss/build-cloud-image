#!/bin/bash

echo "------ creating Rocky 8 ------"
cp ./images/rocky8.qcow2 ./images/rocky8-nchc.qcow2
echo "------ remove auto-login ------"
sudo virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/rocky8-nchc.qcow2
echo "------ use nchc repo ------"
sudo virt-customize --run-command "sed -i 's/mirrorlist\=/\#mirrorlist\=/g' /etc/yum.repos.d/*.repo" -a ./images/rocky8-nchc.qcow2
sudo virt-customize --run-command "sed -i 's/\#baseurl/baseurl/g' /etc/yum.repos.d/*.repo" -a ./images/rocky8-nchc.qcow2
sudo virt-customize --run-command "sed -i 's/\$contentdir/rocky/g' /etc/yum.repos.d/*.repo" -a ./images/rocky8-nchc.qcow2
sudo virt-customize --run-command "sed -i 's/dl\.rockylinux\.org/free\.nchc\.org\.tw/g' /etc/yum.repos.d/*.repo" -a ./images/rocky8-nchc.qcow2
sudo virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/rocky8-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-r8 ./nchc/rhel/cloud.cfg
sudo virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/rocky8-nchc.qcow2
echo "------ prepare disk ------"
sudo virt-sysprep -a ./images/rocky8-nchc.qcow2

echo "------ creating Rocky 9 ------"
cp ./images/rocky9.qcow2 ./images/rocky9-nchc.qcow2
echo "------ remove auto-login ------"
sudo virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/rocky9-nchc.qcow2
echo "------ use nchc repo ------"
sudo virt-customize --run-command "sed -i 's/mirrorlist\=/\#mirrorlist\=/g' /etc/yum.repos.d/*.repo" -a ./images/rocky9-nchc.qcow2
sudo virt-customize --run-command "sed -i 's/\#baseurl/baseurl/g' /etc/yum.repos.d/*.repo" -a ./images/rocky9-nchc.qcow2
sudo virt-customize --run-command "sed -i 's/\$contentdir/rocky/g' /etc/yum.repos.d/*.repo" -a ./images/rocky9-nchc.qcow2
sudo virt-customize --run-command "sed -i 's/dl\.rockylinux\.org/free\.nchc\.org\.tw/g' /etc/yum.repos.d/*.repo" -a ./images/rocky9-nchc.qcow2
sudo virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/rocky9-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-r9 ./nchc/rhel/cloud.cfg
sudo virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/rocky9-nchc.qcow2
echo "------ prepare disk ------"
sudo virt-sysprep -a ./images/rocky9-nchc.qcow2

echo "------ Done ------"
