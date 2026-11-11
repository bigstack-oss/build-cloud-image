#!/bin/bash
# Update the Manila service qcow2: grow to 10G, apt dist-upgrade, qemu-guest-agent,
# and install fstab-generator (timer rewrites /etc/fstab by UUID so share disks
# survive /dev/vdX renames on reboot). Writes a new image; the input is never modified.
#
#   ./update-manila.sh /mnt/cephfs/glance/manila-service-image_epoxy.qcow2 [out.qcow2]
#
# Env: DNS (default 8.8.8.8), SIZE (default 10G), TMPDIR (default /var/tmp),
#      MIRROR (default http://archive.ubuntu.com/ubuntu; e.g. http://tw.archive.ubuntu.com/ubuntu),
#      used only during the build; the image keeps its own sources.list.
# Needs: root, guestfs-tools, internet on this host (the appliance uses the host's).
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }

in=${1:?usage: $0 <manila-service-image.qcow2> [out.qcow2]}
out=${2:-${in%.qcow2}-updated.qcow2}
DNS=${DNS:-8.8.8.8}
SIZE=${SIZE:-10G}
MIRROR=${MIRROR:-http://archive.ubuntu.com/ubuntu}
export LIBGUESTFS_BACKEND=direct

[[ -f $in ]] || die "$in not found"
[[ -e $out ]] && die "$out already exists"
curl -fsS -o /dev/null --max-time 10 "$MIRROR/" \
  || die "this host cannot reach $MIRROR; try MIRROR=http://tw.archive.ubuntu.com/ubuntu or a host with internet"

log=${out%.qcow2}.log
exec > >(tee "$log") 2>&1
echo "==> $(date '+%F %T') $in -> $out (log: $log)"

work=$(mktemp -d "${TMPDIR:-/var/tmp}/.manila-XXXXXX")
trap 'rm -rf "$work"' EXIT
img=$work/img.qcow2

# "<package> <version>" for every installed deb, read from the image's dpkg status.
pkgs() {
  virt-cat -a "$1" /var/lib/dpkg/status | awk '
    /^Package:/ {p=$2} /^Status:/ {s=($4=="installed")} /^Version:/ {v=$2}
    /^$/ {if (s) print p, v; p=v=s=""}
    END  {if (s) print p, v}' | LC_ALL=C sort
}
kernels() { virt-ls -a "$1" /boot/ | sed -n 's/^vmlinuz-//p' | sort -V | xargs; }

echo "==> installed before: kernel $(kernels "$in")"
pkgs "$in" > "$work/before"
column -t "$work/before"
echo "($(wc -l < "$work/before") packages)"

# The guest has no growpart, so grow partition + ext4 from the host with virt-resize.
cur=$(qemu-img info --output=json "$in" | python3 -c 'import json,sys; print(json.load(sys.stdin)["virtual-size"])')
if (( cur < $(numfmt --from=iec "$SIZE") )); then
  echo "==> resize to $SIZE (expand /dev/sda1)"
  qemu-img create -q -f qcow2 "$img" "$SIZE"
  virt-resize --expand /dev/sda1 "$in" "$img"
else
  echo "==> already >= $SIZE, copy only"
  cp --reflink=auto "$in" "$img"
fi

# ---- files installed into the guest ----
cat > "$work/fstab-generator.sh" <<'EOF'
#!/bin/bash
# Rewrite /etc/fstab from what is mounted now, keyed by UUID (manila adds /dev/vdX lines).
fstab=/etc/fstab gen=/etc/fstab_gen log=/var/log/fstab.log bak=/etc/fstab_backup

{
  echo "LABEL=cloudimg-rootfs / ext4 defaults 0 1"
  findmnt -rn -t ext4,xfs -o SOURCE,FSTYPE,TARGET | while read -r dev fstype mnt; do
    [[ $mnt == / ]] && continue
    uuid=$(blkid -s UUID -o value "$dev") && [[ -n $uuid ]] || continue
    echo "UUID=$uuid $mnt $fstype rw,relatime 0 0"
  done
} > "$gen"

if ! cmp -s "$gen" "$fstab"; then
  mkdir -p "$bak"
  cp "$fstab" "$bak/fstab_$(date +%Y%m%d_%H%M%S)"
  echo "$(date) fstab differs, overwriting with $gen" >> "$log"
  cp "$gen" "$fstab"
fi
rm -f "$gen"
EOF

cat > "$work/fstab-generator.service" <<'EOF'
[Unit]
Description=Update Fstab UUID
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/fstab-generator.sh
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

cat > "$work/fstab-generator.timer" <<'EOF'
[Unit]
Description=Periodically regenerate /etc/fstab by UUID

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=fstab-generator.service

[Install]
WantedBy=timers.target
EOF

# DIB's udev rule (99-dhcp-all-interfaces) starts dhcp-interface@<nic> via SYSTEMD_WANTS,
# but once the initramfs has virtio_net (it is rebuilt by the dist-upgrade) the NIC is already plugged
# before switch-root and systemd never queues that unit: no IP, so manila's ssh times out at 300s.
# Configure every NIC from networking.service instead; the script skips NICs that already have config.
cat > "$work/dhcp-all-interfaces.conf" <<'EOF'
[Service]
ExecStartPre=/bin/udevadm settle
ExecStartPre=/usr/local/sbin/dhcp-all-interfaces.sh
EOF

# Runs inside the guest. resolv.conf is a symlink to the systemd-resolved stub (dead in
# the appliance), so point it at $DNS only for apt, then restore the symlink.
cat > "$work/guest.sh" <<EOF
set -eu
export DEBIAN_FRONTEND=noninteractive
mv /etc/resolv.conf /etc/resolv.conf.kbak
echo 'nameserver $DNS' > /etc/resolv.conf
cp -a /etc/apt/sources.list /etc/apt/sources.list.kbak
sed -i 's|http://archive.ubuntu.com/ubuntu|$MIRROR|' /etc/apt/sources.list

apt-get update -o APT::Update::Error-Mode=any
apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold dist-upgrade
apt-get install -y qemu-guest-agent
apt-get -y autoremove

mv -f /etc/resolv.conf.kbak /etc/resolv.conf
mv -f /etc/apt/sources.list.kbak /etc/apt/sources.list
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

echo "==> customize (dist-upgrade, qemu-guest-agent, boot DHCP fix, fstab-generator)"
virt-customize -a "$img" --network \
  --run "$work/guest.sh" \
  --mkdir /etc/systemd/system/networking.service.d \
  --upload "$work/dhcp-all-interfaces.conf:/etc/systemd/system/networking.service.d/dhcp-all-interfaces.conf" \
  --chmod 0644:/etc/systemd/system/networking.service.d/dhcp-all-interfaces.conf \
  --upload "$work/fstab-generator.sh:/usr/local/bin/fstab-generator.sh" \
  --chmod 0755:/usr/local/bin/fstab-generator.sh \
  --upload "$work/fstab-generator.service:/etc/systemd/system/fstab-generator.service" \
  --upload "$work/fstab-generator.timer:/etc/systemd/system/fstab-generator.timer" \
  --chmod 0644:/etc/systemd/system/fstab-generator.service \
  --chmod 0644:/etc/systemd/system/fstab-generator.timer \
  --run-command 'systemctl enable fstab-generator.timer' \
  --run-command 'rm -f /tmp/builder.log'   # stale log; virt-customize dumps it on every error

echo "==> verify"
virt-filesystems -a "$img" --long -h | grep /dev/sda1
virt-ls -l -a "$img" /etc/ | grep 'resolv.conf -> ../run/systemd/resolve/stub-resolv.conf' \
  || die "resolv.conf not restored"
virt-cat -a "$img" /etc/apt/sources.list | grep -q '^deb http://archive.ubuntu.com/ubuntu ' \
  || die "sources.list not restored"
virt-cat -a "$img" /var/lib/dpkg/status | grep -x 'Package: qemu-guest-agent' \
  || die "qemu-guest-agent missing"
virt-cat -a "$img" /etc/systemd/system/networking.service.d/dhcp-all-interfaces.conf \
  | grep -x 'ExecStartPre=/usr/local/sbin/dhcp-all-interfaces.sh' || die "boot DHCP drop-in missing"
virt-cat -a "$img" /etc/network/interfaces | grep -qE '^iface (en|eth)' \
  && die "/etc/network/interfaces has baked NIC config; DHCP script would skip those NICs"
virt-ls -a "$img" /etc/systemd/system/timers.target.wants/ | grep -x fstab-generator.timer \
  || die "fstab-generator.timer not enabled"
virt-cat -a "$img" /usr/local/bin/fstab-generator.sh | bash -n || die "fstab-generator.sh syntax"
pkgs "$img" > "$work/after"

echo "==> sparsify -> $out"
virt-sparsify -q --compress "$img" "$out"

echo "==> summary"
kb=$(kernels "$in") ka=$(kernels "$img")   # grub boots the newest (last) one
echo "kernel (boots): ${kb##* } -> ${ka##* }$([[ ${kb##* } == "${ka##* }" ]] && echo '  (unchanged)')"
echo "kernels installed: $kb -> $ka"
changes=$(LC_ALL=C join -a1 -a2 -e '(none)' -o 0,1.2,2.2 "$work/before" "$work/after" \
  | awk '$2 != $3 {print $1, $2, "->", $3}')
if [[ -n $changes ]]; then column -t <<<"$changes"; else echo "(no package changes)"; fi
echo "$(grep -c . <<<"$changes") package(s) changed; full before list in $log"
echo "Done: $out"
