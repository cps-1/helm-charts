#!/bin/bash

set -euo pipefail

# shellcheck disable=SC2223
: ${CPS1_PYTHON_VERSION:="3.13"}

HOME=/home/user

curl -LsSf https://astral.sh/uv/install.sh | sh

# shellcheck disable=SC1091
source $HOME/.local/bin/env

uv python install "$CPS1_PYTHON_VERSION" --default --preview

# Workaround for https://github.com/astral-sh/python-build-standalone/issues/380
# shellcheck disable=SC2155,SC2046
export PATH=$(dirname $(realpath $(which python))):$PATH

python -m venv $HOME/.venv

export VIRTUAL_ENV_DISABLE_PROMPT=true
# shellcheck disable=SC1091
source "${HOME}/.venv/bin/activate"

uv pip install pipx
uv run pipx install poetry

echo 'VIRTUAL_ENV_DISABLE_PROMPT=1 source /home/user/.venv/bin/activate' >> /home/user/.bashrc

chown -R user:user /home/user/.local
chown -R user:user /home/user/.venv

python --version
pip --version
pipx --version
poetry --version

