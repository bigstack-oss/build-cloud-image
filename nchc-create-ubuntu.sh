#!/bin/bash
# NCHC variants of the Ubuntu images from create-ubuntu.sh: no auto-login, NCHC cloud.cfg (repo).
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d nchc ] || { echo "nchc/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/ubuntu_$1-nchc.qcow2
  echo "------ creating ubuntu $v LTS nchc ------"
  cp "./images/ubuntu_$v.qcow2" "$img"
  g virt-customize -a "$img" \
    --run-command 'rm -rf /lib/systemd/system/getty@tty1.service' \
    --upload "./nchc/ubuntu/cloud.cfg-u${v%.*}:/etc/cloud/cloud.cfg"
  g virt-sysprep -a "$img"
  echo "------ Done ubuntu $v nchc ------"
)

for v in 22.04 24.04 26.04; do build "$v"; done
