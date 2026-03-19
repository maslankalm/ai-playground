terraform {
  required_version = ">= 1.14"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 8.5.0"
    }
  }

  backend "oci" {
    namespace = "frcpdkrgafyo"
    bucket    = "terraform-states"
    key       = "k8s-oci-cluster/terraform.tfstate"
  }
}
