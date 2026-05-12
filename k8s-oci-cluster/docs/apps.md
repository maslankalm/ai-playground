# Application Layer

Argo CD is configured with an app-of-apps entry pointing at [`../apps/`](../apps/). Adding an Application manifest there and pushing to Git is the intended deployment path: Argo CD picks it up, applies it, self-heals drift, and prunes removed resources.

## Current Status

No long-running application manifests are currently committed in the public repo. The previous kube-prometheus-stack experiment proved the GitOps path, but was removed to keep the OCI Always Free cluster inside a practical resource budget.

## Deployment Contract

When apps are added, they should follow the same pattern:

- Application manifests live under `k8s-oci-cluster/apps`.
- Runtime secrets are created by Terraform in `platform/`, not stored in Git.
- Public ingress should stay behind Cloudflare and use cert-manager TLS.
- Resource requests should be realistic for the ARM free-tier nodes.
- Anything too heavy for the free tier should move back to the homelab or be removed rather than quietly degrading the cluster.
