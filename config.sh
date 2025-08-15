#!/bin/bash
set -euo pipefail



function set_qemu_opts {
  export QCOW_NAME=$(\
    ls -la                                            |
    awk '{print $NF}'                                 |
    grep -e 'Fedora-Server-Guest-Generic' -e 'qcow2$' |
    head -n 1
  )

  # ----------------------------------------------------------------------------
  # PER-RUN CONFIGURATION

  export ACCEL_TYPE='kvm'
  export MEMORY='4G'
  export CORES=2
  # ----------------------------------------------------------------------------

}; set_qemu_opts

# ----------------------------------------------------------------------------
# PRE-RUN CONFIGURATION

QCOW_SIZE=20G
ROOT_HASH=$(mkpasswd --method=yescrypt "$(< rootpw)")
DATE=$(( $(date +%s) / 86400 - 1))
# ------------------------------------------------------------------------------



function main {
  if [[ -z "$QCOW_NAME" ]]; then
    echo "QCOW image not found."
    exit 1
  fi

  if [[ ! -f "$QCOW_NAME" ]]; then
    echo "QCOW image '$QCOW_NAME' not found."
    exit 1
  fi

  if [[ "$QCOW_NAME" ]]; then
    qemu-img resize "$QCOW_NAME" "$QCOW_SIZE"
  fi

  echo "Setting root password..."
  virt-customize -a "$QCOW_NAME" --run-command                            \
    "sed -i 's|^root:.*|root:$ROOT_HASH:$DATE:0:99999:7:::|' /etc/shadow" \
    --run-command 'systemctl disable initial-setup' > /dev/null
  echo "Done."
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]
  then set_qemu_opts
  else set_qemu_opts; main
fi
