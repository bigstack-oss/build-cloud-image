#!/bin/bash


echo "------ creating CentOS-Stream-9------"
cp ./images/CentOS-Stream-9.qcow2 ./images/CentOS-Stream-9-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/CentOS-Stream-9-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/CentOS-Stream-9-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-c9 ./nchc/rhel/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/CentOS-Stream-9-nchc.qcow2
cp ./nchc/rhel/centos-addons.repo-c9 ./nchc/rhel/centos-addons.repo
sudo LIBGUESTFS_BACKEND=direct virt-copy-in "./nchc/rhel/centos-addons.repo" /etc/yum.repos.d/ -a ./images/CentOS-Stream-9-nchc.qcow2
cp ./nchc/rhel/centos.repo-c9 ./nchc/rhel/centos.repo
sudo LIBGUESTFS_BACKEND=direct virt-copy-in "./nchc/rhel/centos.repo" /etc/yum.repos.d/ -a ./images/CentOS-Stream-9-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/CentOS-Stream-9-nchc.qcow2

echo "------ Done ------"
