echo "------ creating ubuntu 22.04 LTS ------"
echo "------ install docker repo ------"
sudo virt-customize --run-command "install -m 0755 -d /etc/apt/keyrings" -a ./images/ubuntu2204-k8s.qcow2
cp ./config/ubuntu/docker.list-u22 ./config/ubuntu/docker.list
sudo virt-copy-in './config/ubuntu/docker.list' /etc/apt/sources.list.d/ -a ./images/ubuntu2204-k8s.qcow2
sudo virt-copy-in './config/ubuntu/docker.asc' /etc/apt/keyrings/ -a ./images/ubuntu2204-k8s.qcow2
echo "------ install docker ------"
sudo virt-customize --run-command "apt update -y" -a ./images/ubuntu2204-k8s.qcow2
sudo virt-customize --run-command "apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y" -a ./images/ubuntu2204-k8s.qcow2
#sudo virt-customize --install docker-ce --selinux-relabel -a ./images/ubuntu2204-k8s.qcow2
#sudo virt-customize --install docker-ce-cli --selinux-relabel -a ./images/ubuntu2204-k8s.qcow2
#sudo virt-customize --install containerd.io --selinux-relabel -a ./images/ubuntu2204-k8s.qcow2
#sudo virt-customize --install docker-buildx-plugin --selinux-relabel -a ./images/ubuntu2204-k8s.qcow2
#sudo virt-customize --install docker-compose-plugin --selinux-relabel -a ./images/ubuntu2204-k8s.qcow2

sudo virt-sysprep -a ./images/ubuntu2204-k8s.qcow2
