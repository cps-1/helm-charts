#!/bin/bash
set -euo pipefail

curl -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/$CPS1_KUBECTL_VERSION/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
