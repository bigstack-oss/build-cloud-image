#!/bin/bash
# echo "------ creating debian 10 buster ------"
# rm -rf ./images/debian_10.qcow2
# wget https://cloud.debian.org/images/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2 -O ./images/debian_10.qcow2
# echo "------ install pkg ------"
# sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/debian_10.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/debian_10.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian_10.qcow2
# echo "------ customize settings ------"
# sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/debian_10.qcow2
# cp ./config/debian/getty-d10 ./config/debian/getty@tty1.service
# cp ./config/debian/cloud-d10.cfg ./config/debian/cloud.cfg
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian_10.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian_10.qcow2
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian_10.qcow2
# echo "------ disable kernel auto update ------"
# sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian_10.qcow2
# echo "------ Sysprep ------"
# sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/debian_10.qcow2
# echo "------ Done ------"

echo "------ creating debian 11 bulleye ------"
rm -rf ./images/debian_11.qcow2
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2 -O ./images/debian_11.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "find /etc/apt -type f -name \"*.list\" -exec sed -i -e 's|deb.debian.org|archive.debian.org|g' -e 's|security.debian.org|archive.debian.org|g' {} +" -a ./images/debian_11.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize   --run-command 'apt-get update' \
  --run-command 'DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade' \
  --run-command 'apt-get -y autoremove' \
  --run-command 'apt-get clean' -a ./images/debian_11.qcow2 
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/debian_11.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/debian_11.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian_11.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/debian_11.qcow2
cp ./config/debian/getty-d11 ./config/debian/getty@tty1.service
cp ./config/debian/cloud-d11.cfg ./config/debian/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian_11.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian_11.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian_11.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian_11.qcow2
echo "------ Network Interfaces ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/99-new-interface-dhcp.yaml' /etc/netplan/ -a ./images/debian_11.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "chmod 600 /etc/netplan/99-new-interface-dhcp.yaml" -a ./images/debian_11.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/debian_11.qcow2
echo "------ Done ------"

echo "------ creating debian 12 bookworm ------"
rm -rf ./images/debian_12.qcow2
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2 -O ./images/debian_12.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize   --run-command 'apt-get update' \
  --run-command 'DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade' \
  --run-command 'apt-get -y autoremove' \
  --run-command 'apt-get clean' -a ./images/debian_12.qcow2 
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/debian_12.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/debian_12.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian_12.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/debian_12.qcow2
cp ./config/debian/getty-d12 ./config/debian/getty@tty1.service
cp ./config/debian/cloud-d12.cfg ./config/debian/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian_12.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian_12.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian_12.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian_12.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/motd' /etc/ -a ./images/debian_12.qcow2
echo "------ Network Interfaces ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/99-new-interface-dhcp.yaml' /etc/netplan/ -a ./images/debian_12.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "chmod 600 /etc/netplan/99-new-interface-dhcp.yaml" -a ./images/debian_12.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/debian_12.qcow2
echo "------ Done ------"

echo "------ creating debian 13 trixie ------"
rm -rf ./images/debian_13.qcow2
wget https://cdimage.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2 -O ./images/debian_13.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command 'apt-get update' \
  --run-command 'DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade' \
  --run-command 'apt-get -y autoremove' \
  --run-command 'apt-get clean' -a ./images/debian_13.qcow2 
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-common --selinux-relabel -a ./images/debian_13.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/debian_13.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/debian_13.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/debian_13.qcow2
cp ./config/debian/getty-d13 ./config/debian/getty@tty1.service
cp ./config/debian/cloud-d13.cfg ./config/debian/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/getty@tty1.service' /lib/systemd/system/ -a ./images/debian_13.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/cloud.cfg' /etc/cloud/ -a ./images/debian_13.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/debian_13.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/20auto-upgrades' /etc/apt/apt.conf.d/ -a ./images/debian_13.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/motd' /etc/ -a ./images/debian_13.qcow2
echo "------ Network Interfaces ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/debian/99-new-interface-dhcp.yaml' /etc/netplan/ -a ./images/debian_13.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "chmod 600 /etc/netplan/99-new-interface-dhcp.yaml" -a ./images/debian_13.qcow2
echo "------ Sysprep ------"
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/debian_13.qcow2
echo "------ Done ------"
