#!/usr/bin/env bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run installation as root." >&2
  exit 1
fi

# Check if findmnt command is available
if ! command -v findmnt > /dev/null; then
  echo "Error: 'findmnt' command not found. Please install the 'util-linux' package." >&2
  exit 1
fi

# Check if duperemove command is available
if ! command -v duperemove > /dev/null; then
  echo "Error: 'duperemove' command not found. Please install the 'duperemove' package." >&2
  exit 1
fi

# Install duperemove service and timer files
install -m 755 duperemove-service.sh /usr/local/bin/duperemove-service.sh
install -m 644 duperemove.service /etc/systemd/system/duperemove.service
install -m 644 duperemove.timer /etc/systemd/system/duperemove.timer

# Create directory for duperemove cache
install -d /var/cache/duperemove

# Enable and start the duperemove timer
if ! systemctl enable --now duperemove.timer; then
  echo "Error: Failed to enable and start the duperemove timer." >&2
  exit 1
fi
