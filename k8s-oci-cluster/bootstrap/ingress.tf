resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.1"
  namespace        = "ingress-nginx"
  create_namespace = true

  set = [
    # OCI LB annotations: flexible shape at 10 Mbps to stay within Always Free tier
    {
      name  = "controller.service.annotations.oci\\.oraclecloud\\.com/load-balancer-type"
      value = "lb"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-shape"
      value = "flexible"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-shape-flex-min"
      value = "10"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-shape-flex-max"
      value = "10"
    },
  ]

  set_list = [
    {
      name  = "controller.service.loadBalancerSourceRanges"
      value = var.ingress_source_cidrs
    },
  ]
}
