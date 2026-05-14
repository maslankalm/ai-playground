# GitOps Apps

Argo CD watches this directory through the app-of-apps configuration in `platform/argocd.tf`.

## Prepared apps

- `ollama-router.yaml` -> `ollama-router/`: internal-only Ollama router service using a Tailscale sidecar. Public manifests contain no Tailnet endpoints or API/auth keys; private bootstrap files live under `ollama-router/config/` and non-example config files are ignored by Git.

Add one subdirectory or Application manifest per workload when a service is ready to run on the OCI cluster.
