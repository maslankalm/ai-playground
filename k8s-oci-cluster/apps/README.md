# GitOps Apps

Argo CD watches this directory through the app-of-apps configuration in `platform/argocd.tf`.

## Prepared apps

- `ollama-router.yaml` -> `ollama-router/`: internal-only Ollama router service using a Tailscale sidecar. Public manifests contain no Tailnet endpoints or API/auth keys; private bootstrap files live under `ollama-router/config/` and non-example config files are ignored by Git.
- `k8s-manifest-reviewer.yaml` -> `k8s-manifest-reviewer/`: public Kubernetes manifest reviewer demo using the in-cluster Ollama router and Cloudflare-proxied Ingress. The Ingress caps request bodies at `16k` because the app only accepts small demo manifests.

Add one subdirectory or Application manifest per workload when a service is ready to run on the OCI cluster.
