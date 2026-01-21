#!/bin/bash

set -euo pipefail

HOME=/home/user

apt-get update

apt-get install -y gcc

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs --output /tmp/rustup.sh

su user -c "bash /tmp/rustup.sh -y"

rm /tmp/rustup.sh

# shellcheck disable=SC1091
. "${HOME}/.cargo/env"

rustc --version
