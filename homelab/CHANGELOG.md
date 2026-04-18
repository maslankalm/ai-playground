# Homelab Changelog

Reverse-chronological record of every change to the homelab: cluster updates, new apps, Raspberry Pi work, networking, and AI/learning milestones.

## Format

Each entry is a dated `## YYYY-MM-DD` heading with a short title, followed by:

- **What** — the change, in one or two sentences.
- **Why** — the motivation.
- **Links** — related directories, PRs, or external resources.

---

## 2026-04-18 — Started documenting the homelab

- **What** — Created the `homelab/` directory with this changelog, an architecture overview, and a Mermaid diagram. The first step of the homelab is already in place: a Kubernetes cluster on Oracle Cloud's Always Free tier, driven by Claude Code through GitOps. From here on, every change that touches the homelab gets an entry.
- **Why** — Capturing the AI learning journey from the infrastructure side. Future-me (and anyone reading) should be able to see how the setup evolved, not just what it looks like today.
- **Links** — [`README.md`](README.md), cluster: [`../k8s-oci-cluster/`](../k8s-oci-cluster/), coding agent: [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview).
