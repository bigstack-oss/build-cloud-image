#!/bin/bash


echo "------ creating centos_9------"
cp ./images/centos_9.qcow2 ./images/centos_9-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/centos_9-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/centos_9-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-c9 ./nchc/rhel/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/centos_9-nchc.qcow2
cp ./nchc/rhel/centos-addons.repo-c9 ./nchc/rhel/centos-addons.repo
sudo LIBGUESTFS_BACKEND=direct virt-copy-in "./nchc/rhel/centos-addons.repo" /etc/yum.repos.d/ -a ./images/centos_9-nchc.qcow2
cp ./nchc/rhel/centos.repo-c9 ./nchc/rhel/centos.repo
sudo LIBGUESTFS_BACKEND=direct virt-copy-in "./nchc/rhel/centos.repo" /etc/yum.repos.d/ -a ./images/centos_9-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/centos_9-nchc.qcow2

echo "------ Done ------"

echo "------ creating centos_10------"
cp ./images/centos_10.qcow2 ./images/centos_10-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/centos_10-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/centos_10-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-c10 ./nchc/rhel/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/centos_10-nchc.qcow2
cp ./nchc/rhel/centos-addons.repo-c10 ./nchc/rhel/centos-addons.repo
sudo LIBGUESTFS_BACKEND=direct virt-copy-in "./nchc/rhel/centos-addons.repo" /etc/yum.repos.d/ -a ./images/centos_10-nchc.qcow2
cp ./nchc/rhel/centos.repo-c10 ./nchc/rhel/centos.repo
sudo LIBGUESTFS_BACKEND=direct virt-copy-in "./nchc/rhel/centos.repo" /etc/yum.repos.d/ -a ./images/centos_10-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/centos_10-nchc.qcow2

echo "------ Done ------"
