#!/usr/bin/env bash

set -eE -o pipefail # Enable script to exit immediately on any error

# Function to handle errors
handle_error() {
    local exit_code="$?"
    echo "Error: duperemove failed for $MOUNTPOINT" >&2
    exit "$exit_code"
}

# Trap errors and execute error handling function
trap 'handle_error' ERR

# Get all mount targets with btrfs or xfs filesystem and store in an array
mapfile -t MOUNTPOINTS < <(findmnt -n -t btrfs,xfs -lo target)

# Iterate through each mount point
for MOUNTPOINT in "${MOUNTPOINTS[@]}"; do
    echo "Start duperemove for $MOUNTPOINT"
    duperemove -drh --hashfile="/var/cache/duperemove/hashfile" "$MOUNTPOINT"
done
