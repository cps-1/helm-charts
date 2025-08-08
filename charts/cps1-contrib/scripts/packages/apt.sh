#!/bin/bash
set -euo pipefail

PACKAGES=$(echo "$CPS1_APT_PACKAGES" | tr -d '[]' | tr ',' ' ')
apt-get update
apt-get install -y "$PACKAGES"
