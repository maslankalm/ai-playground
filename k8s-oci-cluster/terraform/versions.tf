terraform {
  required_version = ">= 1.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }

  backend "oci" {
    namespace = "frcpdkrgafyo"
    bucket    = "terraform-states"
    key       = "k8s-oci-cluster/terraform.tfstate"
  }
}
