#!/bin/bash
# Rocky Linux cloud images.
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d config ] || { echo "config/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }
mkdir -p images

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/rocky_$1.qcow2
  echo "------ creating Rocky $v ------"
  wget "https://dl.rockylinux.org/pub/rocky/$v/images/x86_64/$2" -O "$img"
  g virt-customize -a "$img" \
    --install nfs-utils,cifs-utils,qemu-guest-agent \
    --mkdir /etc/docker \
    --upload "./config/rocky/getty-r$v:/lib/systemd/system/getty@tty1.service" \
    --upload "./config/rocky/cloud-r$v.cfg:/etc/cloud/cloud.cfg" \
    --copy-in ./config/daemon.json:/etc/docker \
    --run-command 'sed -i "s/^SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config' \
    --selinux-relabel
  g virt-sysprep -a "$img"
  echo "------ Done Rocky $v ------"
)

build 8  Rocky-8-GenericCloud.latest.x86_64.qcow2
build 9  Rocky-9-GenericCloud.latest.x86_64.qcow2
build 10 Rocky-10-GenericCloud-Base.latest.x86_64.qcow2
