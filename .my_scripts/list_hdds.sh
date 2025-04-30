#!/bin/bash

echo "Detecting mechanical hard drives (HDDs)..."
echo

for disk in /sys/block/*; do
    dev=$(basename "$disk")
    if [[ ! -e "/dev/$dev" ]]; then
        continue
    fi

    # Check if it's a physical disk (not a loop, ram, or device mapper)
    if [[ "$dev" =~ ^(loop|ram|fd|dm-|sr|zram) ]]; then
        continue
    fi

    rotational=$(cat "$disk/queue/rotational" 2>/dev/null)
    if [[ "$rotational" == "1" ]]; then
        model=$(cat "/sys/block/$dev/device/model" 2>/dev/null)
        echo "/dev/$dev - HDD - Model: ${model:-Unknown}"
    fi
done

