# Kubernetes on OCI Free Tier

## Goal

Run AI workloads on a free Kubernetes cluster using Oracle Cloud Infrastructure's Always Free tier.

## Background

Oracle Cloud's [Always Free tier](https://www.oracle.com/cloud/free/) is one of the most generous cloud offers available for experimenting — especially for compute. The OKE (Oracle Kubernetes Engine) control plane is always free, and the Ampere A1 ARM shapes provide solid resources at no cost.

## Based on

Created from scratch based on [nce/oci-free-cloud-k8s](https://github.com/nce/oci-free-cloud-k8s), while covering some documentation gaps found during development.

## Cluster Setup

- **Engine:** Oracle Kubernetes Engine (OKE) — free managed control plane
- **Worker nodes:** 2 nodes, each with 2 vCPU / 12 GB RAM
- **Shape:** VM.Standard.A1.Flex (ARM Ampere A1, from the Always Free allocation of 4 OCPUs / 24 GB RAM)

See [Prerequisites](docs/prerequisites.md) before running Terraform.
