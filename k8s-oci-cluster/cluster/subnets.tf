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

  # OCI cloud controller dynamically adds LB/NodePort rules — let it manage them
  lifecycle {
    ignore_changes = [ingress_security_rules, egress_security_rules]
  }
}

resource "oci_core_security_list" "external" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "external-security-list"

  ingress_security_rules {
    source   = var.k8s_api_source_ip
    protocol = "6" # TCP

    tcp_options {
      min = 6443
      max = 6443
    }
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
  security_list_ids = [oci_core_security_list.internal.id, oci_core_security_list.external.id]
}
