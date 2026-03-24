terraform {
  required_version = ">= 1.14"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36.0"
    }
  }

  backend "oci" {
    namespace = "frcpdkrgafyo"
    bucket    = "terraform-states"
    key       = "k8s-oci-cluster/platform.tfstate"
  }
}