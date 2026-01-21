#!/bin/bash
set -euo pipefail

IFS=',' read -r -a PACKAGES <<< "$(echo "$CPS1_APT_PACKAGES" | tr -d '[:space:][]')"

apt-get update
apt-get install -y "${PACKAGES[@]}"
