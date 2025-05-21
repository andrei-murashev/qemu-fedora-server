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

ACCEL_TYPE='kvm'
MEMORY=4G
CORES=2

# ------------------------------------------------------------------------------

if [[ -z "$QCOW_NAME" ]]; then
  echo "QCOW image not found."
  exit 1
fi

if [[ ! -f "$QCOW_NAME" ]]; then
  echo "QCOW image '$QCOW_NAME' not found."
  exit 1
fi

qemu-system-x86_64              \
  -hda "$QCOW_NAME"             \
  -nographic                    \
  -machine accel="$ACCEL_TYPE"  \
  -m "$MEMORY"                  \
  -smp "$CORES"                 \
  -cpu host                     \
  -sandbox on