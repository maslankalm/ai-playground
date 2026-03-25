# Platform Components

Core services deployed via Terraform (`platform/`). These provide the shared infrastructure that all applications depend on.

| Component | Chart | Version | Namespace |
|---|---|---|---|
| [NGINX Ingress](#nginx-ingress-controller) | `ingress-nginx` | 4.12.1 | `ingress-nginx` |
| [Cert-Manager](#cert-manager) | `cert-manager` | 1.17.1 | `cert-manager` |
| [External-DNS](#external-dns) | `external-dns` | 1.20.0 | `external-dns` |
| [ArgoCD](#argocd) | `argo-cd` | 7.8.13 | `argocd` |

## NGINX Ingress Controller

Exposes cluster services to external traffic through an OCI free-tier flexible load balancer. Source IPs are restricted to Cloudflare CIDR ranges.

## Cert-Manager

Automates TLS certificate issuance and renewal from Let's Encrypt using Cloudflare DNS-01 challenges. Provides a `letsencrypt-prod` ClusterIssuer available cluster-wide.

## External-DNS

Watches Ingress resources and automatically creates/updates Cloudflare DNS records in `sync` mode with Cloudflare proxied mode enabled.

## ArgoCD

Implements GitOps continuous deployment using the app-of-apps pattern. Watches the `apps/` directory and automatically syncs Application manifests to the cluster with self-heal and auto-prune enabled.
