#!/bin/bash
# CentOS Stream cloud images. CentOS 7/8 (EOL, vault repos) are in git history.
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d config ] || { echo "config/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }
mkdir -p images

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/centos_$1.qcow2
  echo "------ creating centos $v ------"
  wget "https://cloud.centos.org/centos/$v-stream/x86_64/images/CentOS-Stream-GenericCloud-$v-latest.x86_64.qcow2" -O "$img"
  g virt-customize -a "$img" \
    --mkdir /etc/docker \
    --upload "./config/centos/getty-c$v:/lib/systemd/system/getty@tty1.service" \
    --upload "./config/centos/cloud-c$v.cfg:/etc/cloud/cloud.cfg" \
    --copy-in ./config/daemon.json:/etc/docker \
    --run-command 'sed -i "s/^SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config' \
    --install nfs-utils,cifs-utils,qemu-guest-agent \
    --run-command 'dnf update -y' \
    --run-command 'dnf clean all' \
    --selinux-relabel
  g virt-sysprep -a "$img"
  echo "------ Done centos $v ------"
)

for v in 9 10; do build "$v"; done
