
#!/bin/bash
echo "------ creating fedora 40 ------"
rm -rf ./images/fedora40.qcow2
wget https://mirror.twds.com.tw/fedora/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2  -O ./images/fedora40.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/fedora40.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/fedora40.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/fedora40.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/fedora40.qcow2
cp ./config/fedora/getty-f40 ./config/fedora/getty@tty1.service
cp ./config/fedora/cloud-f40.cfg ./config/fedora/cloud.cfg
sudo virt-copy-in './config/fedora/getty@tty1.service' /lib/systemd/system/ -a ./images/fedora40.qcow2
sudo virt-copy-in './config/fedora/cloud.cfg' /etc/cloud/ -a ./images/fedora40.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/fedora40.qcow2
echo "------ disable kernel auto update ------"
sudo virt-customize --run-command "echo 'exclude=kernel*' >> /etc/dnf/dnf.conf" -a ./images/fedora40.qcow2
sudo virt-sysprep -a ./images/fedora40.qcow2
echo "------ Done ------"

echo "------ creating fedora 39 ------"
rm -rf ./images/fedora39.qcow2
wget https://mirror.twds.com.tw/fedora/fedora/linux/releases/39/Cloud/x86_64/images/Fedora-Cloud-Base-39-1.5.x86_64.qcow2 -O ./images/fedora39.qcow2
echo "------ install pkg ------"
sudo virt-customize --install nfs-utils --selinux-relabel -a ./images/fedora39.qcow2
sudo virt-customize --install cifs-utils --selinux-relabel -a ./images/fedora39.qcow2
sudo virt-customize --install qemu-guest-agent --selinux-relabel -a ./images/fedora39.qcow2
echo "------ customize settings ------"
sudo virt-customize --run-command "mkdir /etc/docker" -a ./images/fedora39.qcow2
cp ./config/fedora/getty-f39 ./config/fedora/getty@tty1.service
cp ./config/fedora/cloud-f39.cfg ./config/fedora/cloud.cfg
sudo virt-copy-in './config/fedora/getty@tty1.service' /lib/systemd/system/ -a ./images/fedora39.qcow2
sudo virt-copy-in './config/fedora/cloud.cfg' /etc/cloud/ -a ./images/fedora39.qcow2
sudo virt-copy-in './config/daemon.json' /etc/docker/ -a ./images/fedora39.qcow2
echo "------ disable kernel auto update ------"
sudo virt-customize --run-command "echo 'exclude=kernel*' >> /etc/dnf/dnf.conf" -a ./images/fedora39.qcow2
sudo virt-sysprep -a ./images/fedora39.qcow2
echo "------ Done ------"
