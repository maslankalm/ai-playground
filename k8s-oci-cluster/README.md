# Kubernetes on OCI Free Tier

## Goal

Run AI workloads on a free Kubernetes cluster using Oracle Cloud Infrastructure's Always Free tier.

## Background

Oracle Cloud's [Always Free tier](https://www.oracle.com/cloud/free/) is one of the most generous cloud offers available for experimenting — especially for compute. The OKE (Oracle Kubernetes Engine) control plane is always free, and the Ampere A1 ARM shapes provide solid resources at no cost.

## Cluster Setup

- **Engine:** Oracle Kubernetes Engine (OKE) — free managed control plane
- **Worker nodes:** 2 nodes, each with 2 vCPU / 12 GB RAM
- **Shape:** VM.Standard.A1.Flex (ARM Ampere A1, from the Always Free allocation of 4 OCPUs / 24 GB RAM)

## OCI CLI Setup

1. Install the OCI CLI via Homebrew:
   ```bash
   brew install oci-cli
   ```
2. Run `oci setup config` — it will generate a key pair and write `~/.oci/config`.
3. **After setup, you must upload the public key to OCI Console** — the CLI won't work until this is done:
   - Login to [cloud.oracle.com](https://cloud.oracle.com)
   - Top-right → click profile image → **User Settings**
   - Tab → **Tokens and Keys** → **Add API Key**
   - Paste the contents of `~/.oci/oci_api_key_public.pem`
   - Confirm the fingerprint shown by OCI matches the one in `~/.oci/config`
4. Verify with: `oci iam region list`

> **Note:** When asked for a compartment ID (e.g. during cluster creation), use the tenancy OCID — it's the root compartment.

## Terraform Setup (macOS)

### Pre-setup

Create an OCI Object Storage bucket for Terraform remote state (versioning recommended):

```bash
oci os bucket create --name terraform-states --versioning Enabled --compartment-id <tenancy-ocid>
```

### Install

Use the official HashiCorp tap to ensure you get the latest version directly from HashiCorp:

```bash
brew install hashicorp/tap/terraform
```
