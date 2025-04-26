#!/bin/bash

exiting_file="/etc/fstab"
generated_file="/etc/fstab_gen"
LOGFILE="/var/log/fstab.log"
BACKUP_DIR="/etc/fstab_backup"

#generate fstab
echo "LABEL=cloudimg-rootfs / ext4 defaults 0 1" > "$generated_file"
# list disks
lsblk_data=$(lsblk | tail -n +2 | awk '{print $1, $7}')
echo "$lsblk_data" | while read -r disk mount; do
  if [[ -n "$mount" && "$mount" != "/" ]]; then
    disk_uuid=$(blkid /dev/$disk | awk -F'"' '{print $2}')
    echo "UUID=$disk_uuid $mount ext4 rw,relatime 0 0" >> "$generated_file"
  fi
done

# Create the backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup the fstab file
cp "$exiting_file" "$BACKUP_DIR/fstab_$(date +%Y%m%d_%H%M%S)"

# Calculate MD5 hashes for both files
exiting_file_md5=$(md5sum "$exiting_file" | cut -d' ' -f1)
generated_file_md5=$(md5sum "$generated_file" | cut -d' ' -f1)

# Compare the hashes
if [ "$exiting_file_md5" != "$generated_file_md5" ]; then
    echo "$(date) File hashes differ. Overwriting $exiting_file with $generated_file." >> $LOGFILE
    cp "$generated_file" "$exiting_file"
fi

rm -f $generated_file