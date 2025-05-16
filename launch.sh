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

qemu-system-x86_64              \
  -hda "$QCOW_NAME"             \
  -nographic                    \
  -machine accel="$ACCEL_TYPE"  \
  -m "$MEMORY"                  \
  -smp "$CORES"                 \
  -cpu host                     \
  -sandbox on