#!/bin/bash

echo "------ creating Rocky 8 ------"
cp ./images/rocky_8.qcow2 ./images/rocky_8-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/rocky_8-nchc.qcow2
echo "------ use nchc repo ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/mirrorlist\=/\#mirrorlist\=/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_8-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/\#baseurl/baseurl/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_8-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/\$contentdir/rocky/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_8-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/dl\.rockylinux\.org/free\.nchc\.org\.tw/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_8-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/rocky_8-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-r8 ./nchc/rhel/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/rocky_8-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/rocky_8-nchc.qcow2

echo "------ creating Rocky 9 ------"
cp ./images/rocky_9.qcow2 ./images/rocky_9-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/rocky_9-nchc.qcow2
echo "------ use nchc repo ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/mirrorlist\=/\#mirrorlist\=/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_9-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/\#baseurl/baseurl/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_9-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/\$contentdir/rocky/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_9-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/dl\.rockylinux\.org/free\.nchc\.org\.tw/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_9-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/rocky_9-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-r9 ./nchc/rhel/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/rocky_9-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/rocky_9-nchc.qcow2

echo "------ Done ------"

echo "------ creating Rocky 10 ------"
cp ./images/rocky_10.qcow2 ./images/rocky_10-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/rocky_10-nchc.qcow2
echo "------ use nchc repo ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/mirrorlist\=/\#mirrorlist\=/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_10-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/\#baseurl/baseurl/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_10-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/\$contentdir/rocky/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_10-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i 's/dl\.rockylinux\.org/free\.nchc\.org\.tw/g' /etc/yum.repos.d/*.repo" -a ./images/rocky_10-nchc.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf"  -a ./images/rocky_10-nchc.qcow2
cp ./nchc/rhel/cloud.cfg-r10 ./nchc/rhel/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/rhel/cloud.cfg' /etc/cloud/ -a ./images/rocky_10-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/rocky_10-nchc.qcow2

echo "------ Done ------"