# Platform Components

Core services deployed via Terraform (`platform/`). These provide the shared infrastructure that all applications depend on.

| Component | Chart | Version | Namespace |
|---|---|---|---|
| [NGINX Ingress](#nginx-ingress-controller) | `ingress-nginx` | 4.12.1 | `ingress-nginx` |
| [Cert-Manager](#cert-manager) | `cert-manager` | 1.17.1 | `cert-manager` |
| [External-DNS](#external-dns) | `external-dns` | 1.20.0 | `external-dns` |
| [ArgoCD](#argocd) | `argo-cd` | 7.8.13 | `argocd` |

## NGINX Ingress Controller

Exposes cluster services to external traffic through an OCI free-tier flexible load balancer. Source IPs are restricted to Cloudflare CIDR ranges, ensuring all traffic passes through Cloudflare's proxy.

## Cert-Manager

Automates TLS certificate issuance and renewal from Let's Encrypt using Cloudflare DNS-01 challenges. A `ClusterIssuer` named `letsencrypt-prod` is available cluster-wide — Ingress resources reference it via the `cert-manager.io/cluster-issuer` annotation. This enables Cloudflare Full (Strict) TLS mode for end-to-end encryption.

## External-DNS

Watches Ingress resources and automatically creates/updates Cloudflare DNS records. Runs in `sync` mode (removes stale records) with Cloudflare proxied mode enabled. A TXT owner ID (`k8s-oci-cluster`) prevents conflicts with DNS records managed outside the cluster.

## ArgoCD

Implements GitOps continuous deployment using the app-of-apps pattern. An `argocd-apps` Application watches the `apps/` directory in the Git repository and automatically syncs any Application manifests found there. Self-heal and auto-prune are enabled, so the cluster state always matches Git.

- **UI:** `argocd-k8s.<domain>`
- **Default credentials:** `admin` / initial password from `argocd-initial-admin-secret`
