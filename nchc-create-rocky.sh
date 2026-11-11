#!/bin/bash
# NCHC variants of the Rocky images from create-rocky.sh: no auto-login, NCHC NTP + mirror.
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d nchc ] || { echo "nchc/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/rocky_$1-nchc.qcow2
  echo "------ creating Rocky $v nchc ------"
  cp "./images/rocky_$v.qcow2" "$img"
  g virt-customize -a "$img" \
    --run-command 'rm -rf /lib/systemd/system/getty@tty1.service' \
    --run-command "sed -i -e 's/mirrorlist=/#mirrorlist=/g' -e 's/#baseurl/baseurl/g' -e 's/\$contentdir/rocky/g' -e 's/dl\.rockylinux\.org/free.nchc.org.tw/g' /etc/yum.repos.d/*.repo" \
    --run-command "sed -i '3iserver 140.110.16.1 iburst' /etc/chrony.conf" \
    --upload "./nchc/rhel/cloud.cfg-r$v:/etc/cloud/cloud.cfg"
  g virt-sysprep -a "$img"
  echo "------ Done Rocky $v nchc ------"
)

for v in 8 9 10; do build "$v"; done
