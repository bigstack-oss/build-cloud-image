cp ./images/ubuntu2004.qcow2 ./images/rancher-cluster-image.qcow2
sudo virt-copy-in './config/rancher-route/fix-rancher-api-route-on-boot.service' /etc/systemd/system/ -a ./images/rancher-cluster-image.qcow2
sudo virt-copy-in './config/rancher-route/fix-rancher-api-route.timer' /etc/systemd/system/ -a ./images/rancher-cluster-image.qcow2
sudo virt-copy-in './config/rancher-route/fix-rancher-api-route.service' /etc/systemd/system/ -a ./images/rancher-cluster-image.qcow2
sudo virt-copy-in './config/rancher-route/fix-rancher-api-route.sh' /usr/local/bin/ -a ./images/rancher-cluster-image.qcow2
sudo virt-customize --run-command "chmod +x /usr/local/bin/fix-rancher-api-route.sh" -a ./images/rancher-cluster-image.qcow2
sudo virt-customize --run-command "systemctl daemon-reload" -a ./images/rancher-cluster-image.qcow2
sudo virt-customize --run-command "systemctl enable fix-rancher-api-route.timer" -a ./images/rancher-cluster-image.qcow2
sudo virt-customize --run-command "systemctl enable fix-rancher-api-route-on-boot.service" -a ./images/rancher-cluster-image.qcow2
