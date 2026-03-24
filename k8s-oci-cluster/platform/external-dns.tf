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

  values = [yamlencode({
    provider = {
      name = "cloudflare"
    }
    env = [{
      name = "CF_API_TOKEN"
      valueFrom = {
        secretKeyRef = {
          name = "cloudflare-api-token"
          key  = "api-token"
        }
      }
    }]
    domainFilters = [var.domain]
    txtOwnerId    = "k8s-oci-cluster"
    policy        = "sync"
    sources       = ["ingress"]
    extraArgs     = ["--cloudflare-proxied"]
  })]
}
