variable "compartment_id" {
  description = "OCID of the compartment to create resources in"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for worker node access"
  type        = string
}

variable "k8s_api_source_ip" {
  description = "Public IP allowed to reach the K8s API (CIDR, e.g. 203.0.113.5/32)"
  type        = string
}

variable "node_count" {
  description = "Number of worker nodes in the node pool"
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "Kubernetes version for OKE cluster and node pool"
  type        = string
  default     = "v1.35.0"
}
