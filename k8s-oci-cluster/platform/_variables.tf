variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the OKE cluster"
  type        = string
  default     = "~/.kube/k8s-oci-cluster-config"
}

variable "domain" {
  description = "Base domain for ingress hostnames (e.g. example.com)"
  type        = string
}

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt registration"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with Zone:DNS:Edit permission"
  type        = string
  sensitive   = true
}


variable "git_repo_url" {
  description = "Git repository URL for ArgoCD to watch"
  type        = string
  default     = "https://github.com/maslankalm/ai-playground.git"
}

variable "ingress_source_cidrs" {
  description = "CIDRs allowed to reach the ingress load balancer"
  type        = list(string)
  # Cloudflare IPv4 ranges (cloudflare.com/ips-v4/)
  default = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]
}
