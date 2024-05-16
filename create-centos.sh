
#!/bin/bash
echo "------ creating centos 7 ------"
rm -rf ./images/CentOS-7.qcow2
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O ./images/CentOS-7.qcow2
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/CentOS-7.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/CentOS-7.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/CentOS-7.qcow2
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/CentOS-7.qcow2
cp ./config/centos/getty-c7 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c7.cfg ./config/centos/cloud.cfg
sudo virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/CentOS-7.qcow2
sudo virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/CentOS-7.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/CentOS-7.qcow2
sudo virt-sysprep -a ./images/CentOS-7.qcow2


echo "------ creating centos 8 ------"
rm -rf ./images/CentOS-Stream-8.qcow2
wget https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-latest.x86_64.qcow2 -O ./images/CentOS-Stream-8.qcow2
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/CentOS-Stream-8.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/CentOS-Stream-8.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/CentOS-Stream-8.qcow2
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/CentOS-Stream-8.qcow2
cp ./config/centos/getty-c8 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c8.cfg ./config/centos/cloud.cfg
sudo virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/CentOS-Stream-8.qcow2
sudo virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/CentOS-Stream-8.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/CentOS-Stream-8.qcow2
sudo virt-sysprep -a ./images/CentOS-Stream-8.qcow2

echo "------ Done ------"

echo "------ creating centos 9 ------"
rm -rf ./images/CentOS-Stream-9.qcow2
wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 -O ./images/CentOS-Stream-9.qcow2
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/CentOS-Stream-9.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/CentOS-Stream-9.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/CentOS-Stream-9.qcow2
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/CentOS-Stream-9.qcow2
cp ./config/centos/getty-c9 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c9.cfg ./config/centos/cloud.cfg
sudo virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/CentOS-Stream-9.qcow2
sudo virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/CentOS-Stream-9.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/CentOS-Stream-9.qcow2
sudo virt-sysprep -a ./images/CentOS-Stream-9.qcow2

echo "------ Done ------"
