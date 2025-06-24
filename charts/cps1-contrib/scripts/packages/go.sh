#!/bin/bash

set -euo pipefail

HOME=/home/user

# shellcheck disable=SC2223
: ${CPS1_GO_VERSION:="1.24.4"}

cd $HOME
curl -L "https://go.dev/dl/go${CPS1_GO_VERSION}.linux-amd64.tar.gz" --output "${HOME}/go.tar.gz"

tar xzf go.tar.gz
mv go .golang
rm go.tar.gz

# shellcheck disable=SC2016
echo 'export "PATH=${HOME}/.golang/bin:${PATH}"' >> ${HOME}/.bashrc

export "PATH=${HOME}/.golang/bin:${PATH}"

chown -R user:user ${HOME}/.golang/

go version

