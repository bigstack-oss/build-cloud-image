#!/bin/bash
# Ubuntu LTS cloud images: NetworkManager instead of netplan/networkd, no systemd-resolved.
g() { sudo LIBGUESTFS_BACKEND=direct "$@"; }
cd "$(dirname "$0")" || exit 1
[ -d config ] || { echo "config/ not found: copy the whole build-cloud-image dir, not just the script" >&2; exit 1; }
mkdir -p images

# subshell + set -e: a failed step stops this image only, the next one still builds
build() (
  set -e
  v=$1 img=./images/ubuntu_$1.qcow2 u=u${1%.*}
  echo "------ creating ubuntu $v LTS ------"
  wget "https://cloud-images.ubuntu.com/$2/current/$2-server-cloudimg-amd64.img" -O "$img"
  qemu-img resize "$img" 10G
  # own appliance boot so the next one sees the grown partition before resize2fs
  g virt-customize -a "$img" --run-command 'growpart /dev/sda 1'
  # 22.04 ships resolved inside the systemd package (own package from 23.04), so it is
  #   only disabled there; 24.04+ also remove the package.
  # Ubuntu's network-manager ships /usr/lib/NetworkManager/conf.d/10-dns-resolved.conf
  #   forcing dns=systemd-resolved; resolved is removed, so shadow it from /etc and NM
  #   writes /etc/resolv.conf directly from the DHCP lease DNS (OVN subnet DNS).
  # dns-resolve-dir.conf: NM's dns-mgr still tries the systemd-resolved plugin, which
  #   aborts the whole DNS commit when /run/systemd/resolve is missing; tmpfiles.d
  #   recreates that dir every boot so the plugin no-ops.
  # networkd manages nothing now; its wait-online would hang boot forever, so mask it
  #   and let NetworkManager-wait-online satisfy network-online.target.
  g virt-customize -a "$img" \
    --run-command 'resize2fs /dev/sda1' \
    --run-command 'apt-get update' \
    --run-command 'DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade' \
    --run-command 'apt-get -y autoremove' \
    --run-command 'apt-get clean' \
    --install nfs-common,cifs-utils,qemu-guest-agent,net-tools \
    --run-command 'systemctl disable systemd-resolved' \
    --run-command 'if dpkg-query -W systemd-resolved >/dev/null 2>&1; then DEBIAN_FRONTEND=noninteractive apt-get -y remove systemd-resolved; fi' \
    --run-command 'rm -f /etc/resolv.conf' \
    --install network-manager \
    --run-command 'systemctl enable NetworkManager' \
    --copy-in ./config/ubuntu/10-dns-resolved.conf:/etc/NetworkManager/conf.d \
    --copy-in ./config/ubuntu/dns-resolve-dir.conf:/etc/tmpfiles.d \
    --mkdir /etc/docker \
    --upload "./config/ubuntu/getty-$u:/lib/systemd/system/getty@tty1.service" \
    --upload "./config/ubuntu/cloud-$u.cfg:/etc/cloud/cloud.cfg" \
    --copy-in ./config/daemon.json:/etc/docker \
    --copy-in ./config/ubuntu/20auto-upgrades:/etc/apt/apt.conf.d \
    --run-command 'rm -f /etc/netplan/*.yaml' \
    --copy-in ./config/ubuntu/99-network-manager.yaml:/etc/netplan \
    --chmod 0600:/etc/netplan/99-network-manager.yaml \
    --run-command 'systemctl disable systemd-networkd.service' \
    --run-command 'systemctl mask systemd-networkd-wait-online.service' \
    --run-command 'systemctl enable NetworkManager-wait-online.service'
  g virt-sysprep -a "$img"
  echo "------ Done ubuntu $v ------"
)

build 22.04 jammy
build 24.04 noble
build 26.04 resolute
