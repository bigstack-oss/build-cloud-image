#!/bin/bash

echo "------ creating CentOS-Stream-8------"
cp ./images/CentOS-Stream-8.qcow2 ./images/CentOS-Stream-8-nchc.qcow2
echo "------ remove auto-login ------"
sudo virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/CentOS-Stream-8-nchc.qcow2
echo "------ use nchc repo ------"
sudo virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/CentOS-Stream-8-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-c8 ./nchc/rhel/cloud.cfg
sudo virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/CentOS-Stream-8-nchc.qcow2
echo "------ prepare disk ------"
sudo virt-sysprep -a ./images/CentOS-Stream-8-nchc.qcow2

echo "------ creating CentOS-Stream-9------"
cp ./images/CentOS-Stream-9.qcow2 ./images/CentOS-Stream-9-nchc.qcow2
echo "------ remove auto-login ------"
sudo virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/CentOS-Stream-9-nchc.qcow2
sudo virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/CentOS-Stream-9-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-c9 ./nchc/rhel/cloud.cfg
sudo virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/CentOS-Stream-9-nchc.qcow2
echo "------ prepare disk ------"
sudo virt-sysprep -a ./images/CentOS-Stream-9-nchc.qcow2

echo "------ Done ------"
