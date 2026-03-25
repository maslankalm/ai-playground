data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_node_pool_option" "k8s" {
  node_pool_option_id = oci_containerengine_cluster.k8s.id
}

locals {
  node_image_id = [
    for source in data.oci_containerengine_node_pool_option.k8s.sources :
    source.image_id if length(regexall("aarch.*OKE-${replace(var.kubernetes_version, "v", "")}", source.source_name)) > 0
  ][0]
}

resource "oci_containerengine_cluster" "k8s" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "k8s-cluster"
  vcn_id             = module.vcn.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.public.id
  }

  options {
    service_lb_subnet_ids = [oci_core_subnet.public.id]
  }
}

resource "oci_containerengine_node_pool" "workers" {
  cluster_id         = oci_containerengine_cluster.k8s.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "k8s-workers"
  node_shape         = "VM.Standard.A1.Flex"

  node_shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = local.node_image_id
    boot_volume_size_in_gbs = 100
  }

  node_config_details {
    size = var.node_count

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.private.id
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
      subnet_id           = oci_core_subnet.private.id
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
      subnet_id           = oci_core_subnet.private.id
    }
  }

}

data "oci_containerengine_cluster_kube_config" "k8s" {
  cluster_id = oci_containerengine_cluster.k8s.id
}

resource "local_file" "kubeconfig" {
  content         = data.oci_containerengine_cluster_kube_config.k8s.content
  filename        = pathexpand("~/.kube/k8s-oci-cluster-config")
  file_permission = "0400"
}
