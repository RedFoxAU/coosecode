#!/bin/bash

SEARCH_DIR="${1:-/mnt}"

echo "🔍 Recursively scanning for QCOW2/RAW files under: $SEARCH_DIR"

find "$SEARCH_DIR" -type f \( -iname "*.qcow2" -o -iname "*.raw" \) | while read -r file; do
    echo "🔍 Checking file: $file"

    # Connect the file as an NBD device
    NBD_DEV="/dev/nbd0"
    qemu-nbd --connect="$NBD_DEV" "$file" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Failed to attach $file to $NBD_DEV"
        echo "-----------------------------------"
        continue
    fi

    # Give it a second to settle
    sleep 1

    # Check for ZFS pool inside the virtual disk
    ZFS_OUTPUT=$(zpool import -d "$NBD_DEV" 2>/dev/null)

    if echo "$ZFS_OUTPUT" | grep -q "pool:"; then
        echo "✅ ZFS Pool found in $file"
        echo "$ZFS_OUTPUT" | grep -E 'pool:|state:|ONLINE|raidz|mirror' | sed 's/^/   /'
    else
        echo "❌ No ZFS Pool found in $file"
    fi

    # Disconnect NBD device
    qemu-nbd --disconnect "$NBD_DEV"
    echo "-----------------------------------"
done
