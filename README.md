# CPS1 Platform Helm Charts

CPS1 is a self-hosted solution deployed on your Kubernetes cluster, enhancing development workflows with an intuitive templating engine that automates the provisioning of ephemeral development environments.

Platform engineers can easily customize and extend CPS1, eliminate manual setup, and enforce consistency in ephemeral environments, while offering developers self-service and the flexibility they need.

CPS1 tackles the challenges of modern software development, empowering platform engineers to easily deliver a great development experience.

## Requirements

- A valid FQDN
- Kubernetes 1.30+
- Helm 3
- Cert Manager v1.15+
- Nginx Ingress Controller

For further details on requirements, please refer to our documentation: https://docs.cps1.tech

## Add repository

```
helm repo add cps1 https://cps-1.github.io/helm-charts
helm repo update
```

For the next steps we'll use `cps1` as the namespace and that it's already created.

## Step 1: Install CRDs
```
helm install -n cps1 cps1-crds cps1/cps1-crds
```

This chart has no values to be customized, just CRDs.

## Step 2: Install the platform

Customize the chart before installing. See the [values.yaml](./values.yaml) file
or run:
```
helm show values cps1/cps1-platform
```

The two required values that must be set are `hostname` and `enableTLS`.

The `hostname` value must be a valid FQDN.

The `enableTLS` value must be `true`, and requires CertManager installed on your cluster.

You must 

For a working setup, a valid domain name is required.

```
helm install -n cps1 cps1-platform cps1/cps1-platform --set config.hostname=<your_domain> \
   --set enableTLS=true --set clusterIssuer=letsencrypt-prod
```

## Step 3: Install packages, resources and templates

```
helm install -n cps1 cps1-contrib cps1/cps1-contrib
```
