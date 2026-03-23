resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret_v1" "cloudflare_api_token_external_dns" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace_v1.external_dns.metadata[0].name
  }

  data = {
    api-token = var.cloudflare_api_token
  }
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = "1.20.0"
  namespace        = kubernetes_namespace_v1.external_dns.metadata[0].name
  create_namespace = false

  depends_on = [helm_release.ingress_nginx, kubernetes_secret_v1.cloudflare_api_token_external_dns]

  set = [
    {
      name  = "provider.name"
      value = "cloudflare"
    },
    {
      name  = "env[0].name"
      value = "CF_API_TOKEN"
    },
    {
      name  = "env[0].valueFrom.secretKeyRef.name"
      value = "cloudflare-api-token"
    },
    {
      name  = "env[0].valueFrom.secretKeyRef.key"
      value = "api-token"
    },
    {
      name  = "domainFilters[0]"
      value = var.domain
    },
    {
      name  = "txtOwnerId"
      value = "k8s-oci-cluster"
    },
    {
      name  = "policy"
      value = "sync"
    },
    {
      name  = "sources[0]"
      value = "ingress"
    },
    {
      name  = "extraArgs[0]"
      value = "--cloudflare-proxied"
    },
  ]
}
