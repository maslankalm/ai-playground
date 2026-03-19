module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.6.0"

  compartment_id = var.compartment_id

  vcn_name     = "k8s-vcn"
  vcn_dns_label = "k8svcn"
  vcn_cidrs    = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}
