resource "oci_core_security_list" "internal" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "internal-security-list"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    source   = "10.0.0.0/16"
    protocol = "all"
  }
}

resource "oci_core_subnet" "private" {
  compartment_id             = var.compartment_id
  vcn_id                     = module.vcn.vcn_id
  display_name               = "k8s-private-subnet"
  cidr_block                 = "10.0.1.0/24"
  dns_label                  = "k8spriv"
  route_table_id             = module.vcn.nat_route_id
  security_list_ids          = [oci_core_security_list.internal.id]
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "public" {
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  display_name      = "k8s-public-subnet"
  cidr_block        = "10.0.0.0/24"
  dns_label         = "k8spub"
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.internal.id]
}
