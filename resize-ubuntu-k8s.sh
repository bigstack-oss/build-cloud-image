echo "------ creating ubuntu 22.04 LTS ------"
cp ./images/ubuntu2204.qcow2 ./images/ubuntu2204-k8s.qcow2
echo "------ resize ------"
qemu-img resize ./images/ubuntu2204-k8s.qcow2 +37.5G
sudo virt-customize --run-command "growpart /dev/sda 1" -a ./images/ubuntu2204-k8s.qcow2
sudo virt-sysprep -a ./images/ubuntu2204-k8s.qcow2
