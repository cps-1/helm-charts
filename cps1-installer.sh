#!/bin/bash
set -eu

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
BASE_IMAGE="ghcr.io/cps-1/base-image:2024-04-10-7f0f88d9"
CPS1_IMAGE="ghcr.io/cps-1/cps1:v0.1.0-rc6"

docker pull "${BUILDER_IMAGE}"
docker pull "${BASE_IMAGE}"
docker pull "${CPS1_IMAGE}"

kind load docker-image -n cps1 "${BUILDER_IMAGE}"
kind load docker-image -n cps1 "${BASE_IMAGE}"
kind load docker-image -n cps1 "${CPS1_IMAGE}"

kubectl create namespace cps1

helm repo add cps1 https://cps-1.github.io/helm-charts/

helm repo update

helm install -n cps1 --devel cps1-crds cps1/cps1-crds

helm install -n cps1 --devel cps1-platform cps1/cps1-platform

helm install -n cps1 --devel cps1-contrib cps1/cps1-contrib

