#!/bin/bash

echo "------ creating Rocky 8 ------"
rm -rf ./images/rocky_8.qcow2
wget https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2 -O ./images/rocky_8.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/rocky_8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/rocky_8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/rocky_8.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/rocky_8.qcow2
cp ./config/rocky/getty-r8 ./config/rocky/getty@tty1.service
cp ./config/rocky/cloud-r8.cfg ./config/rocky/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/rocky/getty@tty1.service' /lib/systemd/system/ -a ./images/rocky_8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/rocky/cloud.cfg' /etc/cloud/ -a ./images/rocky_8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/rocky_8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command 'sed -i "s/^SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config' -a ./images/rocky_8.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel* linux-firmware*' >> /etc/yum.conf" -a ./images/rocky_8.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/rocky_8.qcow2
echo "------ Done ------"

echo "------ creating Rocky 9 ------"
rm -rf ./images/rocky_9.qcow2
wget https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 -O ./images/rocky_9.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/rocky_9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/rocky_9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/rocky_9.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/rocky_9.qcow2
cp ./config/rocky/getty-r9 ./config/rocky/getty@tty1.service
cp ./config/rocky/cloud-r9.cfg ./config/rocky/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/rocky/getty@tty1.service' /lib/systemd/system/ -a ./images/rocky_9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/rocky/cloud.cfg' /etc/cloud/ -a ./images/rocky_9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/rocky_9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command 'sed -i "s/^SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config' -a ./images/rocky_9.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel* linux-firmware*' >> /etc/yum.conf" -a ./images/rocky_9.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/rocky_9.qcow2
echo "------ Done ------"

echo "------ creating Rocky 10 ------"
rm -rf ./images/rocky_10.qcow2
wget https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 -O ./images/rocky_10.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/rocky_10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/rocky_10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/rocky_10.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/rocky_10.qcow2
cp ./config/rocky/getty-r10 ./config/rocky/getty@tty1.service
cp ./config/rocky/cloud-r10.cfg ./config/rocky/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/rocky/getty@tty1.service' /lib/systemd/system/ -a ./images/rocky_10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/rocky/cloud.cfg' /etc/cloud/ -a ./images/rocky_10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/rocky_10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command 'sed -i "s/^SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config' -a ./images/rocky_10.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel* linux-firmware*' >> /etc/yum.conf" -a ./images/rocky_10.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/rocky_10.qcow2
echo "------ Done ------"