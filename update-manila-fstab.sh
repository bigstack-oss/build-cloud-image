cp ./images/ubuntu2004.qcow2 ./images/manila-service-image.qcow2
sudo virt-copy-in './config/manila-fstab/fstab-generator.timer' /etc/systemd/system/ -a ./images/manila-service-image.qcow2
sudo virt-copy-in './config/manila-fstab/fstab-generator.service' /etc/systemd/system/ -a ./images/manila-service-image.qcow2
sudo virt-copy-in './config/manila-fstab/fstab-generator.sh' /usr/local/bin/ -a ./images/manila-service-image.qcow2
sudo virt-customize --run-command "chmod +x /usr/local/bin/fstab-generator.sh" -a ./images/manila-service-image.qcow2
sudo virt-customize --run-command "systemctl daemon-reload" -a ./images/manila-service-image.qcow2
sudo virt-customize --run-command "systemctl enable fstab-generator.timer" -a ./images/manila-service-image.qcow2
