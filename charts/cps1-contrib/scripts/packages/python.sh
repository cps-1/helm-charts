#!/bin/bash
set -euo pipefail

: "${CPS1_PYTHON_VERSION:='3.13'}"
FULL_VERSION="3.13.7"
HOME=/home/user

case $CPS1_PYTHON_VERSION in
  3.9)
    FULL_VERSION="3.9.23"
    ;;
  3.10)
    FULL_VERSION="3.10.18"
    ;;
  3.11)
    FULL_VERSION="3.11.13"
    ;;
  3.12)
    FULL_VERSION="3.12.11"
    ;;
  # Default to latest stable (3.13)
  *)
    FULL_VERSION="3.13.7"
    ;;
esac

apt-get install -y zstd=1.5.5+dfsg2-2build1

curl -o python.tar.zst \
    -L "https://github.com/astral-sh/python-build-standalone/releases/download/20250918/cpython-${FULL_VERSION}+20250918-x86_64-unknown-linux-gnu-debug-full.tar.zst" && \
    mkdir /opt/python && \
    tar axf python.tar.zst -C /opt/python && \
    rm python.tar.zst

apt-get remove -y --auto-remove zstd

/opt/python/python/install/bin/python -m venv $HOME/.venv

echo "VIRTUAL_ENV_DISABLE_PROMPT=1 source ${HOME}/.venv/bin/activate" >> "${HOME}/.bashrc"

echo "Checking package managers"
if [[ -n "${CPS1_PYTHON_PACKAGE_MANAGER:-}" ]]; then
  echo "Installing $CPS1_PYTHON_PACKAGE_MANAGER"
  $HOME/.venv/bin/pip install "$CPS1_PYTHON_PACKAGE_MANAGER"
else
  echo "No package manager to install"
fi
echo "Checking extra packages"
if [[ -n "${CPS1_PYTHON_PIP_PACKAGES:-}" ]]; then
  echo "Installing $CPS1_PYTHON_PIP_PACKAGES"
  EXTRA_PACKAGES=$(echo "$CPS1_PYTHON_PIP_PACKAGES" | tr -d '[]' | tr ',' ' ')
  $HOME/.venv/bin/pip install "$EXTRA_PACKAGES"
else
  echo "No extra packages to install"
fi
