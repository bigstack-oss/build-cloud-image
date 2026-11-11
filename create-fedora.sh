#!/bin/bash
# Fedora cloud images, same customization as create-rocky.sh.
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d config ] || { echo "config/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }
mkdir -p images

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/fedora_$1.qcow2
  echo "------ creating fedora $v ------"
  # EOL releases live on the archive, not on regular mirrors
  wget "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/$v/Cloud/x86_64/images/$2" -O "$img"
  g virt-customize -a "$img" \
    --install nfs-utils,cifs-utils,qemu-guest-agent \
    --mkdir /etc/docker \
    --upload "./config/fedora/getty-f$v:/lib/systemd/system/getty@tty1.service" \
    --upload "./config/fedora/cloud-f$v.cfg:/etc/cloud/cloud.cfg" \
    --copy-in ./config/daemon.json:/etc/docker \
    --run-command 'sed -i "s/^SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config' \
    --selinux-relabel
  g virt-sysprep -a "$img"
  echo "------ Done fedora $v ------"
)

build 40 Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2
build 39 Fedora-Cloud-Base-39-1.5.x86_64.qcow2
