#!/bin/bash
echo "------ creating ubuntu 20.04 LTS ------"
cp ./images/ubuntu2004.qcow2 ./images/ubuntu2004-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/ubuntu2004-nchc.qcow2
echo "------ use nchc repo ------"
cp ./nchc/ubuntu/cloud.cfg-u20 ./nchc/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu2004-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu2004-nchc.qcow2

echo "------ creating ubuntu 22.04 LTS ------"
cp ./images/ubuntu2204.qcow2 ./images/ubuntu2204-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/ubuntu2204-nchc.qcow2
echo "------ use nchc repo ------"
cp ./nchc/ubuntu/cloud.cfg-u22 ./nchc/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu2204-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu2204-nchc.qcow2

echo "------ creating ubuntu 24.04 LTS ------"
cp ./images/ubuntu2404.qcow2 ./images/ubuntu2404-nchc.qcow2
echo "------ remove auto-login ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "rm -rf /lib/systemd/system/getty@tty1.service" -a ./images/ubuntu2404-nchc.qcow2
echo "------ use nchc repo ------"
cp ./nchc/ubuntu/cloud.cfg-u24 ./nchc/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './nchc/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu2404-nchc.qcow2
echo "------ prepare disk ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu2404-nchc.qcow2

echo "------ Done ------"
