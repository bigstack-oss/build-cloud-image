#!/bin/bash
# Debian cloud images, same customization as create-ubuntu.sh
# (see the comments there for why the NetworkManager/DNS steps exist).
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d config ] || { echo "config/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }
mkdir -p images

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/debian_$1.qcow2
  echo "------ creating debian $v $2 ------"
  wget "https://cloud.debian.org/images/cloud/$2/latest/debian-$v-genericcloud-amd64.qcow2" -O "$img"
  qemu-img resize "$img" 10G
  # own appliance boot so the next one sees the grown partition before resize2fs
  g virt-customize -a "$img" --run-command 'growpart /dev/sda 1'

  pre=() net=()
  if [ "$v" = 11 ]; then
    # bullseye is EOL: its repos moved to archive.debian.org
    pre=(--run-command "find /etc/apt -type f -name \"*.list\" -exec sed -i -e 's|deb.debian.org|archive.debian.org|g' -e 's|security.debian.org|archive.debian.org|g' {} +")
  else
    # 12+ cloud images use netplan + networkd like Ubuntu; 11 uses ifupdown and keeps it.
    # No 'systemctl disable systemd-resolved': the unit may not exist, uninstall covers it.
    net=(
      --uninstall systemd-resolved
      --run-command 'rm -f /etc/resolv.conf'
      --install network-manager
      --run-command 'systemctl enable NetworkManager'
      --copy-in ./config/ubuntu/10-dns-resolved.conf:/etc/NetworkManager/conf.d
      --copy-in ./config/ubuntu/dns-resolve-dir.conf:/etc/tmpfiles.d
      --run-command 'rm -f /etc/netplan/*.yaml'
      --copy-in ./config/ubuntu/99-network-manager.yaml:/etc/netplan
      --chmod 0600:/etc/netplan/99-network-manager.yaml
      --run-command 'systemctl disable systemd-networkd.service'
      --run-command 'systemctl mask systemd-networkd-wait-online.service'
      --run-command 'systemctl enable NetworkManager-wait-online.service'
    )
  fi

  g virt-customize -a "$img" \
    --run-command 'resize2fs /dev/sda1' \
    "${pre[@]}" \
    --run-command 'apt-get update' \
    --run-command 'DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade' \
    --run-command 'apt-get -y autoremove' \
    --run-command 'apt-get clean' \
    --install nfs-common,cifs-utils,qemu-guest-agent,net-tools \
    --mkdir /etc/docker \
    --upload "./config/debian/getty-d$v:/lib/systemd/system/getty@tty1.service" \
    --upload "./config/debian/cloud-d$v.cfg:/etc/cloud/cloud.cfg" \
    --copy-in ./config/daemon.json:/etc/docker \
    --copy-in ./config/debian/20auto-upgrades:/etc/apt/apt.conf.d \
    "${net[@]}"
  g virt-sysprep -a "$img"
  echo "------ Done debian $v ------"
)

build 11 bullseye
build 12 bookworm
build 13 trixie
