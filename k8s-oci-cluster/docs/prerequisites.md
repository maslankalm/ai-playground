# Prerequisites (macOS)

## OCI CLI

```bash
brew install oci-cli
oci setup config          # generates key pair + writes ~/.oci/config
```

Upload the generated public key (`~/.oci/oci_api_key_public.pem`) to OCI Console:
**User Settings** → **Tokens and Keys** → **Add API Key**

Verify: `oci iam region list`

## Terraform

```bash
brew install hashicorp/tap/terraform
```

### Remote State

Create a bucket for Terraform remote state:

```bash
oci os bucket create --name terraform-states --versioning Enabled --compartment-id <tenancy-ocid>
```

Look up your tenancy namespace and substitute it into `_versions.tf` in both `infrastructure/` and `platform/`:

```bash
oci os ns get --query data --raw-output
```

### Variables

Each Terraform directory has its own `terraform.tfvars` (gitignored). Copy `terraform.tfvars.example` and fill in the values.

> [!NOTE]
> Platform variables are for cluster core components. Argo CD app runtime secrets should be handled in each app's ignored `config/` files, with committed `.example` templates for the expected shape.
