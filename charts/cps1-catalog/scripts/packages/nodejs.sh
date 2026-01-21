#!/bin/bash

set -euo pipefail

HOME=/home/user

# shellcheck disable=SC2223
: ${CPS1_NODEJS_VERSION:="v24"}

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"

# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install "${CPS1_NODEJS_VERSION}"
nvm alias default "${CPS1_NODEJS_VERSION}"

chown -R user:user /home/user/.nvm

node --version
