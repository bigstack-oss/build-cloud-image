#!/bin/bash
# Update an Octavia amphora qcow2: grow to 10G, newest kernel, qemu-guest-agent,
# and copy in getty@tty1.service (console autologin as the cloud-init default user).
# Writes a new image; the input is never modified. No user is created in the image.
#
#   ./update-amphora.sh amphora-x64-haproxy_epoxy.qcow2 [out.qcow2]
#
# Env: DNS (default 8.8.8.8), SIZE (default 10G).
# Needs: root, libguestfs-tools, internet on this host (the appliance uses the host's),
#        getty@tty1.service next to this script.
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }

in=${1:?usage: $0 <amphora.qcow2> [out.qcow2]}
out=${2:-${in%.qcow2}-updated.qcow2}
unit="$(dirname "$0")/getty@tty1.service"
DNS=${DNS:-8.8.8.8}
SIZE=${SIZE:-10G}
export LIBGUESTFS_BACKEND=direct

[[ -f $in ]] || die "$in not found"
[[ -f $unit ]] || die "$unit not found"
[[ -e $out ]] && die "$out already exists"
curl -fsS -o /dev/null --max-time 10 http://archive.ubuntu.com/ubuntu/ \
  || die "this host cannot reach archive.ubuntu.com; run on a host with internet"

log=${out%.qcow2}.log
exec > >(tee "$log") 2>&1
echo "==> $(date '+%F %T') $in -> $out (log: $log)"

work=$(mktemp -d "$(dirname "$out")/.amphora-XXXXXX")
trap 'rm -rf "$work"' EXIT

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

echo "==> copy + resize to $SIZE"
cp --reflink=auto "$in" "$work/img.qcow2"
cur=$(qemu-img info --output=json "$work/img.qcow2" | python3 -c 'import json,sys; print(json.load(sys.stdin)["virtual-size"])')
if (( cur < $(numfmt --from=iec "$SIZE") )); then qemu-img resize "$work/img.qcow2" "$SIZE"; fi

# Runs inside the guest. The amphora has nsswitch "hosts: files" and resolv.conf
# pointing at the systemd-resolved stub, so DNS is switched on only for apt, then restored.
cat > "$work/guest.sh" <<EOF
set -eu
export DEBIAN_FRONTEND=noninteractive
growpart /dev/sda 1 || [ \$? -eq 1 ]   # exit 1 = already grown
resize2fs /dev/sda1

cp -a /etc/nsswitch.conf /etc/nsswitch.conf.kbak
mv /etc/resolv.conf /etc/resolv.conf.kbak
sed -i 's/^hosts:.*/hosts: files dns/' /etc/nsswitch.conf
echo 'nameserver $DNS' > /etc/resolv.conf

apt-get update -o APT::Update::Error-Mode=any
apt-get install -y linux-image-virtual qemu-guest-agent

mv -f /etc/resolv.conf.kbak /etc/resolv.conf
mv -f /etc/nsswitch.conf.kbak /etc/nsswitch.conf

new=\$(ls /boot/vmlinuz-* | sed 's|/boot/vmlinuz-||' | sort -V | tail -1)
for k in \$(ls /boot/vmlinuz-* | sed 's|/boot/vmlinuz-||'); do
  [ "\$k" = "\$new" ] || apt-get purge -y "linux-image-\$k" "linux-modules-\$k"
done
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

echo "==> customize (grow fs, kernel, qemu-guest-agent, getty@tty1.service)"
virt-customize -a "$work/img.qcow2" --network \
  --run "$work/guest.sh" \
  --upload "$unit:/etc/systemd/system/getty@tty1.service" \
  --chmod 0644:/etc/systemd/system/getty@tty1.service \
  --run-command 'rm -f /tmp/builder.log'   # stale log; virt-customize dumps it on every error

echo "==> verify"
kernels=$(virt-ls -a "$work/img.qcow2" /boot/ | grep '^vmlinuz-')
[[ $(wc -l <<<"$kernels") -eq 1 ]] || die "expected one kernel, got: $kernels"
virt-cat -a "$work/img.qcow2" /etc/nsswitch.conf | grep -E '^hosts:[[:space:]]+files[[:space:]]*$' \
  || die "nsswitch.conf not restored"
virt-ls -l -a "$work/img.qcow2" /etc/ | grep 'resolv.conf -> ../run/systemd/resolve/stub-resolv.conf' \
  || die "resolv.conf not restored"
virt-cat -a "$work/img.qcow2" /var/lib/dpkg/status | grep -x 'Package: qemu-guest-agent' \
  || die "qemu-guest-agent missing"
virt-cat -a "$work/img.qcow2" /etc/systemd/system/getty@tty1.service | grep '^ExecStart=' \
  || die "getty@tty1.service not installed"
virt-cat -a "$work/img.qcow2" /boot/grub/grub.cfg | grep -E '^\s*linux\s'
pkgs "$work/img.qcow2" > "$work/after"

echo "==> sparsify -> $out"
virt-sparsify -q --compress "$work/img.qcow2" "$out"

echo "==> summary"
kb=$(kernels "$in") ka=$(kernels "$work/img.qcow2")   # grub boots the newest (last) one
echo "kernel (boots): ${kb##* } -> ${ka##* }$([[ ${kb##* } == "${ka##* }" ]] && echo '  (unchanged)')"
echo "kernels installed: $kb -> $ka"
changes=$(LC_ALL=C join -a1 -a2 -e '(none)' -o 0,1.2,2.2 "$work/before" "$work/after" \
  | awk '$2 != $3 {print $1, $2, "->", $3}')
if [[ -n $changes ]]; then column -t <<<"$changes"; else echo "(no package changes)"; fi
echo "$(grep -c . <<<"$changes") package(s) changed; full before list in $log"
echo "Done: $out"
