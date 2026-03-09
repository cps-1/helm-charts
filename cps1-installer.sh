#!/bin/bash

set -euo pipefail

# This script installs CPS1 on a local environment for evaluation.
# For a production grade installation, refer to our documentation at https://docs.cps1.tech

get_latest_version() {
  case $1 in
    kind)
      curl -sI https://github.com/kubernetes-sigs/kind/releases/latest | grep -i location: | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n1
      ;;
    helm)
      curl -sI https://github.com/helm/helm/releases/latest | grep -i location: | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n1
      ;;
    kubectl)
      curl -sL https://dl.k8s.io/release/stable.txt
      ;;
    docker)
      curl -s https://github.com/docker/cli/tags.atom | grep '<title>v' | grep -vE 'rc|alpha|beta' | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'
      ;;
    *)
      return 1
      ;;
  esac
}

get_current_version() {
  case $1 in
    kind)
      kind version | awk '{print $2}' | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'
      ;;
    helm)
      helm version --template='{{.Version}}' | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'
      ;;
    kubectl)
      kubectl version --client | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n1
      ;;
    docker)
      docker version --format '{{.Client.Version}}' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
      ;;
    *)
      return 1
      ;;
  esac
}

check_dependencies () {
  commands=("kind" "docker" "helm" "kubectl")
  missing=()

  echo "Checking requirements..."

  for cmd in "${commands[@]}"; do
    if command -v "${cmd}" > /dev/null 2>&1; then
      echo "✅ '${cmd}' is available."

      # shellcheck disable=SC2310
      current_v=$(get_current_version "${cmd}" 2>/dev/null || echo "")
      current_v=${current_v#v}
      # shellcheck disable=SC2310
      latest_v=$(get_latest_version "${cmd}" 2>/dev/null || echo "")
      latest_v=${latest_v#v}

      if [[ -n "${current_v}" && -n "${latest_v}" ]]; then
        highest_v=$(printf "%s\n%s" "${current_v}" "${latest_v}" | sort -V | tail -n1)
        if [[ "${current_v}" != "${highest_v}" ]]; then
          echo "   ⚠️  Warning: '${cmd}' version (${current_v}) is older than the latest (${latest_v})."
        fi
      fi
    else
      echo "❌ '${cmd}' is MISSING."
      missing+=("${cmd}")
    fi
  done

  if [[ ${#missing[@]} -ne 0 ]]; then
    echo ""
    echo "The following commands were not found:"
    for m in "${missing[@]}"; do
      echo " - ${m}"
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

  CPS1_IMAGE="ghcr.io/cps-1/cps1:latest"

  docker pull "${CPS1_IMAGE}"

  kind load docker-image -n cps1 "${CPS1_IMAGE}"

  kubectl create namespace cps1

  helm repo add cps1 https://helm.cps1.tech

  helm repo update

  helm install -n cps1 cps1-crds cps1/cps1-crds

  helm install -n cps1 cps1-platform cps1/cps1-platform --set config.tls.enabled=false \
	  --set config.hostname=cps1.localhost

  helm install -n cps1 cps1-catalog cps1/cps1-catalog --set 'includeTemplates={nodejs}'

  echo "⏳ Waiting for template build..."
  if ! WAIT_OUT=$(kubectl -n cps1 wait --timeout=300s --for='jsonpath={.status.conditions[?(@.type=="LastSnapshotBuildReady")].status}=True' template/nodejs-env 2>&1); then
    echo "${WAIT_OUT}"
    echo ""
    echo "   ⚠️  Warning: CPS1 is installed, but the initial template build is taking too long."
    echo "      Login into CPS1 and verify by accessing http://cps1.localhost:3001/templates/nodejs-env/logs"
    echo ""
  else
    echo "✅ Template build is ready!"
    echo ""
    echo "Access CPS1 on ▶️  http://cps1.localhost:3001 to create an initial Admin account."
    echo ""
  fi

}

do_install
