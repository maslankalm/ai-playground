# Applications

Applications deployed via ArgoCD from the `apps/` directory. Adding a new Application manifest and pushing to Git is all that's needed — ArgoCD picks it up automatically.

## Kube-Prometheus-Stack

Full monitoring and observability stack.

| Component | Details |
|---|---|
| **Chart** | `kube-prometheus-stack` v72.* |
| **Namespace** | `monitoring` |

### Sub-components

- **Prometheus** — metrics collection and storage, 15-day retention on 10Gi persistent volume
- **Grafana** — dashboards and visualization, with Ingress and TLS via cert-manager
- **Alertmanager** — alert routing and grouping, 2Gi persistent volume
- **Node Exporter** — host-level metrics from each worker node
- **Kube-State-Metrics** — Kubernetes object state metrics (deployments, pods, etc.)

## Loki + Promtail

Centralized log aggregation. Promtail (DaemonSet) collects container logs from each node and ships them to Loki. Queryable via the Loki datasource in Grafana.

| Component | Details |
|---|---|
| **Loki chart** | `loki` v6.* (monolithic mode, filesystem storage) |
| **Promtail chart** | `promtail` v6.* |
| **Namespace** | `monitoring` |
