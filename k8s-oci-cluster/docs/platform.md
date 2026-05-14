# Platform Layer

Core services deployed via Terraform from `platform/`. This layer turns the raw OKE cluster into a small public-facing GitOps platform: ingress, DNS automation, TLS, platform/core secrets, and Argo CD.

| Component | Chart | Version | Namespace |
|---|---|---|---|
| [NGINX Ingress](#nginx-ingress-controller) | `ingress-nginx` | 4.15.1 | `ingress-nginx` |
| [Cert-Manager](#cert-manager) | `cert-manager` | 1.20.0 | `cert-manager` |
| [External-DNS](#external-dns) | `external-dns` | 1.20.0 | `external-dns` |
| [ArgoCD](#argocd) | `argo-cd` | 9.4.15 | `argocd` |

## NGINX Ingress Controller

Exposes cluster services through an OCI flexible load balancer sized for the free-tier setup. Source IPs are restricted to Cloudflare CIDR ranges so public traffic reaches the cluster through the proxied edge instead of directly.

## Cert-Manager

Automates TLS certificate issuance and renewal from Let's Encrypt using Cloudflare DNS-01 challenges. Provides a `letsencrypt-prod` `ClusterIssuer` available cluster-wide.

## External-DNS

Watches Ingress resources and automatically creates/updates Cloudflare DNS records in `sync` mode with Cloudflare proxied mode enabled.

## ArgoCD

Implements GitOps continuous deployment using the app-of-apps pattern. Watches the `apps/` directory and automatically syncs Application manifests to the cluster with self-heal and auto-prune enabled.

## Secrets

Terraform-managed secrets in `platform/` are only for cluster core components, such as Cloudflare tokens used by cert-manager and external-dns. App-specific runtime secrets do **not** belong in platform Terraform; each Argo CD app should keep committed `.example` templates and ignored real files under its own `config/` directory.
