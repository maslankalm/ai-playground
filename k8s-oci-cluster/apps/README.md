# GitOps Apps

Argo CD watches this directory through the app-of-apps configuration in `platform/argocd.tf`.

No long-running application manifests are currently committed here. Add one subdirectory or Application manifest per workload when a service is ready to run on the OCI cluster.
