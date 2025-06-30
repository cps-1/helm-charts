#!/bin/bash

set -euo pipefail

# This script installs CPS1 on a local environment for evaluation.
# For a production grade installation, refer to our documentation at https://docs.cps1.tech

check_dependencies () {
  commands=("kind" "docker" "helm" "kubectl")
  missing=()

  echo "Checking requirements..."

  for cmd in "${commands[@]}"; do
    if which "$cmd" > /dev/null 2>&1; then
      echo "✅ '$cmd' is available."
    else
      echo "❌ '$cmd' is MISSING."
      missing+=("$cmd")
    fi
  done

  if [ ${#missing[@]} -ne 0 ]; then
    echo ""
    echo "The following commands were not found:"
    for m in "${missing[@]}"; do
      echo " - $m"
    done
    exit 1
  fi
}

do_install () {

  check_dependencies

  kind delete cluster -n cps1

  cat <<EOF | kind create cluster -n cps1 --config=-
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30001
    hostPort: 3001
    protocol: TCP
  - containerPort: 30022
    hostPort: 2222
    protocol: TCP
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
EOF

  kubectl config set-context kind-cps1 --namespace cps1

  BUILDER_IMAGE="quay.io/buildah/stable:latest"
  BASE_IMAGE="ghcr.io/cps-1/base-image:20250624"
  CPS1_IMAGE="ghcr.io/cps-1/cps1:v0.1.0-rc9"

  docker pull "${BUILDER_IMAGE}"
  docker pull "${BASE_IMAGE}"
  docker pull "${CPS1_IMAGE}"

  kind load docker-image -n cps1 "${BUILDER_IMAGE}"
  kind load docker-image -n cps1 "${BASE_IMAGE}"
  kind load docker-image -n cps1 "${CPS1_IMAGE}"

  kubectl create namespace cps1

  helm repo add cps1 https://helm.cps1.tech

  helm repo update

  helm install -n cps1 cps1-crds cps1/cps1-crds

  helm install -n cps1 cps1-platform cps1/cps1-platform --set config.tls.enabled=false \
	  --set config.hostname=cps1.localhost

  helm install -n cps1 cps1-contrib cps1/cps1-contrib --set 'includeTemplates={nodejs,python}'

}

do_install
