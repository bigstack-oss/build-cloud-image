#!/bin/bash
# echo "------ creating ubuntu 20.04 LTS ------"
# rm -rf ./images/ubuntu_20.04.qcow2
# wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O ./images/ubuntu_20.04.qcow2
# echo "------ install pkg ------"
# sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/ubuntu_20.04.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/ubuntu_20.04.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/ubuntu_20.04.qcow2
# echo "------ customize settings ------"
# sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/ubuntu_20.04.qcow2
# cp ./config/ubuntu/getty-u20 ./config/ubuntu/getty@tty1.service
# cp ./config/ubuntu/cloud-u20.cfg ./config/ubuntu/cloud.cfg
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/getty@tty1.service' /lib/systemd/system/ -a ./images/ubuntu_20.04.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu_20.04.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/ubuntu_20.04.qcow2
# echo "------ disable kernel auto update ------"
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/ubuntu_20.04.qcow2
# echo "------ Sysprep ------"
# sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu_20.04.qcow2
# echo "------ Done ------"

echo "------ creating ubuntu 22.04 LTS ------"
rm -rf ./images/ubuntu_22.04.qcow2
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O ./images/ubuntu_22.04.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/ubuntu_22.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/ubuntu_22.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/ubuntu_22.04.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/ubuntu_22.04.qcow2
cp ./config/ubuntu/getty-u22 ./config/ubuntu/getty@tty1.service
cp ./config/ubuntu/cloud-u22.cfg ./config/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/getty@tty1.service' /lib/systemd/system/ -a ./images/ubuntu_22.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu_22.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/ubuntu_22.04.qcow2
echo "------ CVE fix ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "apt install --only-upgrade openssh-client openssh-server -y sudo" -a ./images/ubuntu_22.04.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/ubuntu_22.04.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu_22.04.qcow2
echo "------ Done ------"

echo "------ creating ubuntu 24.04 LTS ------"
rm -rf ./images/ubuntu_24.04.qcow2
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -O ./images/ubuntu_24.04.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/ubuntu_24.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/ubuntu_24.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/ubuntu_24.04.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/ubuntu_24.04.qcow2
cp ./config/ubuntu/getty-u24 ./config/ubuntu/getty@tty1.service
cp ./config/ubuntu/cloud-u24.cfg ./config/ubuntu/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/getty@tty1.service' /lib/systemd/system/ -a ./images/ubuntu_24.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/cloud.cfg' /etc/cloud/ -a ./images/ubuntu_24.04.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/ubuntu_24.04.qcow2
echo "------ CVE fix ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "apt install --only-upgrade openssh-client openssh-server -y sudo" -a ./images/ubuntu_24.04.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/ubuntu/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/ubuntu_24.04.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/ubuntu_24.04.qcow2
echo "------ Done ------"
