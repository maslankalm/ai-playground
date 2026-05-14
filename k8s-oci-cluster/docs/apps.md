# Application Layer

Argo CD is configured with an app-of-apps entry pointing at [`../apps/`](../apps/). Adding an Application manifest there and pushing to Git is the intended deployment path: Argo CD picks it up, applies it, self-heals drift, and prunes removed resources.

## Current Status

`ollama-router` is prepared as the first internal application workload. It is intentionally `ClusterIP`-only: no public ingress, no load balancer, and no router auth in front of it. Backend endpoints and API/auth keys are supplied by private Kubernetes Secrets created from ignored app-local `config/` files, not public GitOps files.

No monitoring stack is currently managed here; app manifests should stay lightweight and explicit.

## Deployment Contract

When apps are added, they should follow the same pattern:

- Application manifests live under `k8s-oci-cluster/apps`.
- App-specific runtime config lives under that app's `config/` directory: commit `.example` templates, ignore filled files without the `.example` suffix, and apply those local files before syncing the app.
- Platform Terraform is reserved for cluster core secrets/components, not per-app runtime secrets.
- Public ingress should stay behind Cloudflare and use cert-manager TLS.
- Resource requests should be realistic for the ARM free-tier nodes.
- Anything too heavy for the free tier should move back to the homelab or be removed rather than quietly degrading the cluster.
