#!/bin/bash
echo "------ creating debian 10 buster ------"
rm -rf ./images/debian-10-buster.qcow2
wget https://cloud.debian.org/images/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2 -O ./images/debian-10-buster.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-common --selinux-relabel -a ./images/debian-10-buster.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/debian-10-buster.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian-10-buster.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/debian-10-buster.qcow2
cp ./config/debian/getty-d10 ./config/debian/getty@tty1.service
cp ./config/debian/cloud-d10.cfg ./config/debian/cloud.cfg
sudo virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian-10-buster.qcow2
sudo virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian-10-buster.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian-10-buster.qcow2
echo "------ disable kernel auto update ------"
sudo virt-copy-in './config/ubuntu/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian-10-buster.qcow2
sudo virt-sysprep -a ./images/debian-10-buster.qcow2
echo "------ Done ------"

echo "------ creating debian 11 bulleye ------"
rm -rf ./images/debian-11-bulleye.qcow2
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2 -O ./images/debian-11-bulleye.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-common --selinux-relabel -a ./images/debian-11-bulleye.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/debian-11-bulleye.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian-11-bulleye.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/debian-11-bulleye.qcow2
cp ./config/debian/getty-d11 ./config/debian/getty@tty1.service
cp ./config/debian/cloud-d11.cfg ./config/debian/cloud.cfg
sudo virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian-11-bulleye.qcow2
sudo virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian-11-bulleye.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian-11-bulleye.qcow2
echo "------ disable kernel auto update ------"
sudo virt-copy-in './config/ubuntu/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian-11-bulleye.qcow2
sudo virt-sysprep -a ./images/debian-11-bulleye.qcow2
echo "------ Done ------"


echo "------ creating debian 12 bookworm ------"
rm -rf ./images/debian-12-bookworm.qcow2
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2 -O ./images/debian-12-bookworm.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-common --selinux-relabel -a ./images/debian-12-bookworm.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/debian-12-bookworm.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian-12-bookworm.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/debian-12-bookworm.qcow2
cp ./config/debian/getty-d12 ./config/debian/getty@tty1.service
cp ./config/debian/cloud-d12.cfg ./config/debian/cloud.cfg
sudo virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian-12-bookworm.qcow2
sudo virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian-12-bookworm.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian-12-bookworm.qcow2
echo "------ disable kernel auto update ------"
sudo virt-copy-in './config/ubuntu/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian-12-bookworm.qcow2
sudo virt-sysprep -a ./images/debian-12-bookworm.qcow2
echo "------ Done ------"
