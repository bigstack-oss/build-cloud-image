#!/bin/bash
echo "------ creating ubuntu 20.04 LTS ------"
cp ./images/ubuntu_20.04.qcow2 ./images/ubuntu_20.04-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/ubuntu_20.04-nchc.qcow2
echo "------ use nchc repo ------"
cp ./nchc/ubuntu/cloud.cfg-u20 ./nchc/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu_20.04-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu_20.04-nchc.qcow2

echo "------ creating ubuntu 22.04 LTS ------"
cp ./images/ubuntu_22.04.qcow2 ./images/ubuntu_22.04-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/ubuntu_22.04-nchc.qcow2
echo "------ use nchc repo ------"
cp ./nchc/ubuntu/cloud.cfg-u22 ./nchc/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu_22.04-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu_22.04-nchc.qcow2

echo "------ creating ubuntu 24.04 LTS ------"
cp ./images/ubuntu_24.04.qcow2 ./images/ubuntu_24.04-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/ubuntu_24.04-nchc.qcow2
echo "------ use nchc repo ------"
cp ./nchc/ubuntu/cloud.cfg-u24 ./nchc/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu_24.04-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu_24.04-nchc.qcow2

echo "------ Done ------"
