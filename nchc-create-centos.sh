#!/bin/bash
# NCHC variants of the CentOS images from create-centos.sh: no auto-login, NCHC NTP + repos.
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d nchc ] || { echo "nchc/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/centos_$1-nchc.qcow2
  echo "------ creating centos $v nchc ------"
  cp "./images/centos_$v.qcow2" "$img"
  g virt-customize -a "$img" \
    --run-command 'rm -rf /lib/systemd/system/getty@tty1.service' \
    --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf" \
    --upload "./nchc/rhel/cloud.cfg-c$v:/etc/cloud/cloud.cfg" \
    --upload "./nchc/rhel/centos-addons.repo-c$v:/etc/yum.repos.d/centos-addons.repo" \
    --upload "./nchc/rhel/centos.repo-c$v:/etc/yum.repos.d/centos.repo"
  g virt-sysprep -a "$img"
  echo "------ Done centos $v nchc ------"
)

for v in 9 10; do build "$v"; done
