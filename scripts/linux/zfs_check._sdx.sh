#!/bin/bash
# Checks all sdX drives for ZFS pools

echo "🔍 Scanning all /dev/sd* devices and partitions for ZFS pools..."

for disk in /dev/sd?; do
    echo "Checking raw device: $disk"
    zdb -l "$disk" 2>/dev/null | grep -i name && echo ""
done

for part in /dev/sd?*; do
    echo "Checking partition: $part"
    zdb -l "$part" 2>/dev/null | grep -i name && echo ""
done

echo "✅ Scan complete."
