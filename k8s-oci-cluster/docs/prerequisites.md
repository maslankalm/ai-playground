# Prerequisites (macOS)

## OCI CLI Setup

### Install

Install the OCI CLI via Homebrew:

```bash
brew install oci-cli
```

### Configure

Run `oci setup config` — it will generate a key pair and write `~/.oci/config`.

### Upload API Key

The CLI won't work until you upload the generated public key to OCI Console:

- Login to [cloud.oracle.com](https://cloud.oracle.com)
- Top-right → click profile image → **User Settings**
- Tab → **Tokens and Keys** → **Add API Key**
- Paste the contents of `~/.oci/oci_api_key_public.pem`
- Confirm the fingerprint shown by OCI matches the one in `~/.oci/config`

### Verify

Check that the CLI is configured correctly:

```bash
oci iam region list
```

## Terraform Setup

### Install

Use the official HashiCorp tap to ensure you get the latest version directly from HashiCorp:

```bash
brew install hashicorp/tap/terraform
```

### OCI Object Storage (Remote State)

Create a bucket for Terraform remote state (versioning recommended):

```bash
oci os bucket create --name terraform-states --versioning Enabled --compartment-id <tenancy-ocid>
```

The OCI backend in `versions.tf` uses a `namespace` value that is tenancy-specific. Look up yours with:

```bash
oci os ns get --query data --raw-output
```

Substitute the result into the `namespace` field in `versions.tf`.
