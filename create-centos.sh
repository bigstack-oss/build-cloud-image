
#!/bin/bash
echo "------ creating centos 7 ------"
rm -rf ./images/centos-7.qcow2
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O ./images/centos-7.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/centos-7.qcow2
cp ./config/centos/getty-c7 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c7.cfg ./config/centos/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/centos-7.qcow2
echo "------ update repo ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-Base.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-CR.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-Debuginfo.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-fasttrack.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-Media.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-Sources.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-Vault.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos7-vault/CentOS-x86_64-kernel.repo' /etc/yum.repos.d/ -a images/centos-7.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/centos-7.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel*' >> /etc/yum.conf" -a ./images/centos-7.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/centos-7.qcow2


echo "------ creating centos 8 ------"
rm -rf ./images/centos-stream-8.qcow2
wget https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-latest.x86_64.qcow2 -O ./images/centos-stream-8.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/centos-stream-8.qcow2
cp ./config/centos/getty-c8 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c8.cfg ./config/centos/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/centos-stream-8.qcow2
echo "------ update repo ------"
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-AppStream.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-BaseOS.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-Debuginfo.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-Extras-common.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-Extras.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-HighAvailability.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-Media.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-NFV.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-PowerTools.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-RealTime.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-ResilientStorage.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos8-vault/CentOS-Stream-Sources.repo' /etc/yum.repos.d/ -a images/centos-stream-8.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/centos-stream-8.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel*' >> /etc/yum.conf" -a ./images/centos-stream-8.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/centos-stream-8.qcow2
echo "------ Done ------"

echo "------ creating centos 9 ------"
rm -rf ./images/centos-stream-9.qcow2
wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 -O ./images/centos-stream-9.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/centos-stream-9.qcow2
cp ./config/centos/getty-c9 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c9.cfg ./config/centos/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/centos-stream-9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/centos-stream-9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/centos-stream-9.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/centos-stream-9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/centos-stream-9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/centos-stream-9.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel*' >> /etc/yum.conf" -a ./images/centos-stream-9.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/centos-stream-9.qcow2
echo "------ Done ------"

echo "------ creating centos 10 ------"
rm -rf ./images/centos-stream-10.qcow2
wget https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2 -O ./images/centos-stream-10.qcow2
echo "------ customize settings ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "mkdir /etc/docker" -a ./images/centos-stream-10.qcow2
cp ./config/centos/getty-c10 ./config/centos/getty@tty1.service
cp ./config/centos/cloud-c10.cfg ./config/centos/cloud.cfg
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/getty@tty1.service' /lib/systemd/system/ -a ./images/centos-stream-10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/centos/cloud.cfg' /etc/cloud/ -a ./images/centos-stream-10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/centos-stream-10.qcow2
echo "------ install pkg ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --install nfs-utils --selinux-relabel -a ./images/centos-stream-10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install cifs-utils --selinux-relabel -a ./images/centos-stream-10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/centos-stream-10.qcow2
echo "------ disable kernel auto update ------"
sudo LIBGUESTFS_BACKEND=direct virt-customize --run-command "echo 'exclude=kernel*' >> /etc/yum.conf" -a ./images/centos-stream-10.qcow2
sudo LIBGUESTFS_BACKEND=direct virt-sysprep -a ./images/centos-stream-10.qcow2
echo "------ Done ------"