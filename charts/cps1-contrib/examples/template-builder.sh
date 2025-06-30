#!/bin/bash
#
# shellcheck disable=SC2223
#
# This is an example of how CPS1 will run the installation script of each package
# during the build of a container image for a workspace template
#

: ${TEMPLATE_NAME:="default"}
: ${TEMPLATE_VERSION:="1"}
: ${BASE_IMAGE:="ghcr.io/cps-1/base-image:latest"}
: ${REGISTRY:="docker://cps1-registry:5000"}

buildah from --name "${TEMPLATE_NAME}" "${BASE_IMAGE}"

buildah run --env CPS1_NODE_VERSION=v20 --volume /scripts:/scripts "${TEMPLATE_NAME}" bash /scripts/packages/nodejs.sh

buildah run --env CPS1_PYTHON_VERSION=3.12 --volume /scripts:/scripts "${TEMPLATE_NAME}" bash /scripts/packages/python.sh

buildah commit "${TEMPLATE_NAME}" "${TEMPLATE_NAME}"

# TODO: add both tags: current version and latest
buildah push --tls-verify=false "localhost/${TEMPLATE_NAME}" "${REGISTRY}/cps1/${TEMPLATE_NAME}:${TEMPLATE_VERSION}"

