resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.15.1"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [yamlencode({
    controller = {
      service = {
        annotations = {
          "oci.oraclecloud.com/load-balancer-type"                      = "lb"
          "service.beta.kubernetes.io/oci-load-balancer-shape"          = "flexible"
          "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" = "10"
          "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" = "10"
        }
        loadBalancerSourceRanges = var.ingress_source_cidrs
      }
    }
  })]
}
