# CPS1 Platform Helm Charts

CPS1 is a self-hosted Cloud Development Environment solution deployed in your Kubernetes cluster. It enhances development workflows with an intuitive templating engine that automates the provisioning of ephemeral development environments.

Platform engineers can easily customize and extend CPS1, eliminating manual setup and enforcing consistency, while offering developers the self-service capabilities and flexibility they need.

CPS1 tackles the challenges of modern software development, empowering platform teams to deliver a great developer experience.

## 🚀 Quick Install

For proof-of-concept scenarios, we provide an installation script that installs CPS1 locally, without requiring a Kubernetes cluster.

1. Prerequisites

Ensure the following tools are installed on your system:
- Docker
- Kind
- Helm
- kubectl

2. Install Command

```
curl https://helm.cps1.tech/cps1-installer.sh | bash
```

## ☁️ Kubernetes Deployment

### 1. Infrastructure requirements
- Kubernetes version 1.30 or higher
- Helm
- Cert Manager
- Nginx Ingress Controller

### 2. DNS requirements:

CPS1 requires two DNS records:
- A record for `cps1.example.com`, used by the Ingress
- A wildcard record for `*.cps1.example.com`, used by the LoadBalancer

The availability of IP addresses for the Ingress and LoadBalancer depends on how your cluster is provisioned and managed.

For full details on DNS setup, refer to the official documentation:
https://docs.cps1.tech

### 3. Add CPS1 chart repository

```
helm repo add cps1 https://helm.cps1.tech
helm repo update
```

Note: The following steps assume the `cps1` namespace has already been created.

### 4. Install CPS1 Custom Resouce Definitions

CRDs must be installed first. This step is required and does not support custom values.
```
helm install -n cps1 cps1-crds cps1/cps1-crds
```

### 5. Install CPS1 Platform

The installation requires two mandatory configuration values:
- `config.hostname`: The fully qualified domain name for your deployment
- `config.tls.clusterIssuer`: A valid ClusterIssuer configured in Cert Manager to issue TLS certificates

Minimal install command:
```
helm install -n cps1 cps1-platform cps1/cps1-platform \ 
  --set config.hostname=<your_domain> \
  --set config.tls.clusterIssuer=<your_cluster_issuer>
```

To review all configurable options, including GitHub and GitLab integration, run:
```
helm show values cps1/cps1-platform
```

Great! You can now use CPS1 for free with up to 10 developers. To add more seats, contact our team at [contact@cps1.tech](mailto:contact@cps1.tech).

### 6. Install packages, resources and templates

CPS1 Contrib is a curated collection of packages, resources, and templates that extend the capabilities of the CPS1 platform.

For details about supported languages, tools, and configurations, visit the CPS1 Contrib repository: [https://github.com/cps-1/helm-charts/tree/main/charts/cps1-contrib](https://github.com/cps-1/helm-charts/tree/main/charts/cps1-contrib).

The command below installs all packages and resources, and includes only the development environment templates for NodeJS and Python.
```
helm install -n cps1 cps1-contrib cps1/cps1-contrib --set includeTemplates={nodejs,python}
```

We welcome contributions of additional packages, resources, and templates to CPS1 Contrib!

If you encounter any issues or have feedback, please open an issue in our repository: [https://github.com/cps-1/cps1](https://github.com/cps-1/cps1)