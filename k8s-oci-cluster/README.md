# Kubernetes on OCI Free Tier

## Goal

Run AI workloads on a free Kubernetes cluster using Oracle Cloud Infrastructure's Always Free tier.

## Background

Oracle Cloud's [Always Free tier](https://www.oracle.com/cloud/free/) is one of the most generous cloud offers available for experimenting — especially for compute. The OKE (Oracle Kubernetes Engine) control plane is always free, and the Ampere A1 ARM shapes provide solid resources at no cost.

Inspired by [nce/oci-free-cloud-k8s](https://github.com/nce/oci-free-cloud-k8s), rewritten with additional documentation and configuration changes.

## Cluster Setup

- **Engine:** Oracle Kubernetes Engine (OKE) — free managed control plane
- **Worker nodes:** 2 nodes, each with 2 vCPU / 12 GB RAM
- **Shape:** VM.Standard.A1.Flex (ARM Ampere A1, from the Always Free allocation of 4 OCPUs / 24 GB RAM)

See [Prerequisites](docs/prerequisites.md) before running Terraform.

## Usage

Deploy the cluster:

```bash
cd terraform
terraform init
terraform apply
```

`terraform apply` creates a kubeconfig file at `~/.kube/k8s-oci-cluster-config`. Use it to interact with the cluster:

```bash
export KUBECONFIG=~/.kube/k8s-oci-cluster-config
kubectl get nodes
```

> [!TIP]
> **A1 capacity availability** — Free-tier A1 instances share a limited capacity pool and `terraform apply` may fail with an "Out of capacity" error. If this happens repeatedly, consider upgrading your account to **Pay As You Go (PAYG)**. PAYG moves you into the regular capacity pool, which is far less congested. Your Always Free limits (4 OCPUs / 24 GB RAM) still apply, so you won't be charged as long as you stay within them.

## Teardown

```bash
terraform destroy
```
