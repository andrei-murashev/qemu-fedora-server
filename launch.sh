#!/bin/bash
set -euo pipefail
source config.sh

qemu-system-x86_64              \
  -hda "$QCOW_NAME"             \
  -machine accel="$ACCEL_TYPE"  \
  -m "$MEMORY"                  \
  -smp "$CORES"                 \
  -cpu host                     \
  -sandbox on                   \
  -nographic