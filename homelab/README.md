# Homelab

Living documentation of my homelab — the infrastructure side of an AI learning journey. This directory captures *what's running*, *how the pieces fit together*, and *every change along the way*.

Kept cost-free where possible (free tiers, self-hosting, local models) so the focus stays on learning.

## Current state

A Kubernetes cluster on Oracle Cloud drives GitOps workloads, and a dedicated HP node runs AI agents via OpenClaw.

```mermaid
graph LR
    CC["Claude Code<br/><i>coding agent</i>"]
    REPO["ai-playground repo<br/><i>GitHub</i>"]
    K8S["OCI k8s cluster<br/><i>Oracle Always Free</i>"]
    HP["HP Compaq Elite 8300<br/><i>Docker host</i>"]
    OC["OpenClaw<br/><i>AI agent platform</i>"]
    SX["SearXNG<br/><i>web search</i>"]
    OPENAI["OpenAI Codex<br/><i>cloud model</i>"]
    DISCORD["Discord<br/><i>chat interface</i>"]

    CC -->|commits / PRs| REPO
    REPO -->|ArgoCD GitOps| K8S
    HP --> OC
    OC --> SX
    OC -->|OpenAI Codex subscription| OPENAI
    OC -->|bot| DISCORD
```

## Components

| Component | Role | Link |
|---|---|---|
| Claude Code | Coding agent driving all changes in this repo | [docs](https://docs.anthropic.com/en/docs/claude-code/overview) |
| OCI k8s cluster | Compute target for workloads, GitOps via ArgoCD | [`../k8s-oci-cluster/`](../k8s-oci-cluster/) |
| HP Compaq Elite 8300 | Dedicated Docker host for AI agents and automation | — |
| OpenClaw | AI agent platform, OpenAI Codex subscription | `http://localhost:18789` via SSH tunnel |
| SearXNG | Local web search backend for OpenClaw | port `8080` on `hp` |

## Changelog

Every homelab change — across the cluster, future edge devices, networking, and AI milestones — is logged in [`CHANGELOG.md`](CHANGELOG.md) in reverse-chronological order.
