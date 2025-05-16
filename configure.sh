#!/bin/bash

# ------------------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------------------

QCOW_NAME=$(                                          \
  ls -la                                              \
  | awk '{print $NF}'                                 \
  | grep -e 'Fedora-Server-Guest-Generic' -e 'qcow2$' \
  | head -n 1                                         \
)

QCOW_SIZE=20G
ROOT_HASH=$(mkpasswd --method=yescrypt 'root')
DATE=$(( $(date +%s) / 86400 - 1))

# ------------------------------------------------------------------------------

qemu-img resize "$QCOW_NAME" "$QCOW_SIZE"

virt-customize -a "$QCOW_NAME" --run-command                            \
  "sed -i 's|^root:.*|root:$ROOT_HASH:$DATE:0:99999:7:::|' /etc/shadow" \
  --run-command 'systemctl disable initial-setup'