#!/bin/bash

QCOW_LINK=$(
  chromium-browser --headless --disable-gpu --dump-dom                \
  --password-store=basic 'https://fedoraproject.org/server/download'  \
  | sed -e 's/>/>\n/g'                                                \
  | grep 'Fedora-Server-Guest-Generic'                                \
  | grep 'x86_64'                                                     \
  | grep -oP '"\K[^"]+(?=")'                                          \
  | head -n1
)


CHECKSUM_LINK="\
https://ap.edge.kernel.org\
$(echo "$QCOW_LINK" \
  | sed -e 's/.qcow2$//'                \
  | sed -e 's/-Guest-Generic//g'        \
  | sed -e 's/.*\/fedora\//\/fedora\//' \
  | sed -e 's/\/linux//'                \
  | sed 's/\(.*\)\./\1-/'
)-CHECKSUM"


# curl -SLO "$CHECKSUM_LINK"
CHECKSUM_FILE=$(echo "$CHECKSUM_LINK" | sed -e 's!.*/!!')

sha256sum -c "$CHECKSUM_FILE" 2>/dev/null
CHECKSUM_STATUS="$?"

if [[ "$CHECKSUM_STATUS" != 0 ]]; then
  echo "SUM CHECK FAILED: Downloading latest server image."
  # curl -SLO "$QCOW_LINK"
fi
