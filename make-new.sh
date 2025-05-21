#!/bin/bash

function backup_file {
  [[ -z $1 ]] && return 1

  readarray -t USED_HEXES < <(ls -a | grep -oP '.bak-[0-9-aA-fF]{16}$')

  while [[ *"$HEX"* == "${USED_HEXES[*]}" || -z "$HEX" ]]; do
    HEX=$(openssl rand -hex 8)
  done

  mv -v "$1" "$1.bak-$HEX"
}





while [[ -z "$QCOW_LINK" ]]; do
  QCOW_LINK=$(
    chromium-browser --headless --disable-gpu --dump-dom                \
    --password-store=basic 'https://fedoraproject.org/server/download'  \
    | sed  's/>/>\n/g'                                                  \
    | grep -e 'Fedora-Server-Guest-Generic' -e 'x86_64'                 \
    | grep -oP '"\K[^"]+(?=")'                                          \
    | head -n1
  )
done

CHECKSUM_LINK="\
https://ap.edge.kernel.org\
$(echo "$QCOW_LINK" \
  | sed                           \
  -e 's/.qcow2$//'                \
  -e 's/-Guest-Generic//g'        \
  -e 's/.*\/fedora\//\/fedora\//' \
  -e 's/\/linux//'                \
  -e 's/\(.*\)\./\1-/'
)-CHECKSUM"


curl -sSLO "$CHECKSUM_LINK"
CHECKSUM_FILE=$(echo "$CHECKSUM_LINK" | sed 's!.*/!!')

CHECKSUM_EXPECTED=$(cat "$CHECKSUM_FILE" | grep '^SHA256' | awk '{print $NF}')
CHECKSUM_CURRENT=$(sha512sum 'Fedora-Server-Guest-Generic'*'.qcow2' \
  2> /dev/null | awk '{print $1}' || echo 0)

[[ "$CHECKSUM_CURRENT" == "$CHECKSUM_EXPECTED" ]]
CHECKSUM_STATUS="$?"

if [[ "$CHECKSUM_STATUS" != 0 ]]; then
  read -p "Download latest image? [y/N]: " ans

  if [[ "${ans^^}" == 'Y' || "${ans^^}" == 'YES' ]]; then
    QCOW_FILE=$(ls -a | grep '.qcow2$' | grep 'Fedora-Server-Guest-Generic')
    backup_file "$QCOW_FILE" || true
    curl -SLO "$QCOW_LINK"

  else
    exit 0
  fi

else
  echo "A clean image already exists in this directory."
fi