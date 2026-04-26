# Homelab Changelog

Reverse-chronological record of every change to the homelab: cluster updates, new apps, Raspberry Pi work, networking, and AI/learning milestones.

## Format

Each entry is a dated `## YYYY-MM-DD` heading with a short title, followed by:

- **What** — the change, in one or two sentences.
- **Why** — the motivation.
- **Links** — related directories, PRs, or external resources.

Keep entries focused on *what changed* and *why*. Host-internal paths, ports, and other operational specifics belong in runbooks, not here. Include **Links** only when they point somewhere meaningful to a reader (repos, docs, sibling homelab dirs).

---

## 2026-04-26

### OpenClaw: GPT-5.5-only Leah with lean internal workers

- **What** — Simplified the OpenClaw agent model so Leah is the only persistent user-facing agent, now backed by GPT-5.5 with a platform-wide "never below high" thinking policy. Specialist models remain available as internal workers rather than visible standalone agents: GLM 5.1 and MiniMax for coding, DeepSeek V4 Flash / Gemma / Kimi for research, plus GPT-5.5 workers and `opus-expert` for critique or escalation.
- **Why** — Reduces operational confusion, avoids stale visible worker sessions, and keeps the Discord control plane centered on one primary operator while preserving delegated labor for real work.

### Rigwarden: wake/status control for GPU rigs

- **What** — Built and deployed Rigwarden on the HP host as a Dockerized Wake-on-LAN and lightweight status API for `rtx-i5`. Validated stop/start power-cycle behavior after enabling WoL on the rig, then narrowed Rigwarden's service boundary to wake/status only. The service is intended to move later to a Raspberry Pi colocated with the rigs.
- **Why** — Keeps GPU rigs off by default to save electricity, while still allowing Leah/OpenClaw to bring local hardware online when a job actually needs it. The wake/status-only boundary also keeps the future Raspberry Pi controller small and low-risk.

### Vidscribe: internal video transcript service on `rtx-i5`

- **What** — Built and pushed Vidscribe as a Dockerized transcript artifact service. It accepts video URLs/IDs, prefers existing captions when available, writes structured transcript artifacts, and falls back to local faster-whisper STT on `rtx-i5` when captions are unavailable. Added HTTP artifact listing/download endpoints so other tools can consume transcripts through the API.
- **Why** — Provides a reusable video-to-transcript utility without copying transcripts into random directories or depending on manual container file access.

### Workspace and platform boundaries clarified

- **What** — Split real development work from OpenClaw's operating workspace so repositories, services, and project scripts live separately from agent memory, channel policies, mission notes, docs, helper scripts, and lightweight scratch. Also documented a Docker-first development rule for HP, rigs, Raspberry Pis, and future nodes.
- **Why** — Keeps code visible and manually operable, keeps OpenClaw's workspace focused on agent operations, and avoids unnecessary host OS mutation across the homelab.

---

## 2026-04-25

### OpenClaw: GPT-5.5 workstream lanes and long-run task cleanup

- **What** — Promoted GPT-5.5 as the main OpenClaw model, with GPT-5.4 retained only as fallback during the transition. Clarified Discord channel boundaries and retired the old "Overnight Research" procedure name in favor of simpler long-run task docs and reusable result artifacts.
- **Why** — Makes OpenClaw easier to operate across separate chat lanes while keeping long-running work auditable and resumable.

### GPU rig power-control plan

- **What** — Documented the plan to keep GPU rigs off by default and wake them only when needed, with a Raspberry Pi planned as a future colocated controller. Current routing remains cloud-first for supported Ollama workloads, with local GPU used for workloads that specifically need local hardware.
- **Why** — Reduces electricity usage while preserving access to local GPU capacity when it is useful.

---

## 2026-04-23

### rtx-i5: first private inference rig on an old desktop

- **What** — Repurposed an old i5-9400F / 32 GB / RTX 1080 desktop as `rtx-i5`, a private local-inference node. Ubuntu Server, NVIDIA driver stack, Docker with the NVIDIA container toolkit, and Ollama running in Docker with `--gpus all`. Validated headless (no display attached). LAN-only and private — no public exposure for inference endpoints.
- **Why** — Adds a GPU-backed local inference option alongside the Ollama cloud delegates, as a cost-free testbed for running models on owned hardware. Also establishes a repeatable bootstrap pattern to reuse on future private rigs.

### OpenClaw: per-lane model benchmarks for Ollama delegates

- **What** — Ran OpenClaw's benchmark pack across the Ollama cloud candidates and picked per-lane defaults instead of a single winner. Coding lane: GLM 5.1 leads with MiniMax as backup; Qwen3 Coder dropped from default coding duty for being too noisy and inefficient despite being technically capable. Research lane: a Kimi / Gemma / DeepSeek trio with role-specific assignments (DeepSeek for hard tradeoffs, Gemma for structured synthesis, Kimi for breadth and overnight runs).
- **Why** — The delegates added on 04-21 were configured by reputation, not evidence. A bounded benchmark (tiny edit, one-file fix, multi-step fix for coding; structured summary, comparative analysis, recommendation memo for research) gives a defensible routing rule and flags which models cost more supervision than they save.

---

## 2026-04-21

### opus-expert: Claude advisory system on HP

- **What** — Built `opus-expert` on the HP node — a Claude Code wrapper with a CLI (`ask-opus`) and an internal REST API. Supports one-shot queries and named advisory sessions with full thread continuity.
- **Why** — OpenClaw could not use the Claude subscription directly, so this keeps Claude available to the homelab within subscription limits. Sessions stay persistent, local, and auditable.

### OpenClaw: Ollama cloud delegates for coding, analysis, engineering

- **What** — Wired OpenClaw to Ollama's hosted models and set up three dedicated delegate agents, each with its own workspace and role brief: `qwen-coder` (Qwen3 Coder) for implementation and refactors, `gemma-analyst` (Gemma 4 31B) for tradeoff analysis and research, and `glm-engineer` (GLM 5.1) for deep debugging and systems investigation.
- **Why** — Not every task needs the primary assistant. Delegating narrow, well-scoped work to cheaper cloud models keeps costs down and frees the main thread for higher-value work. Each delegate has an explicit role and boundary so outputs stay reviewable.

---

## 2026-04-20 — HP homelab node running OpenClaw with OpenAI + Discord + SearXNG

- **What** — Added an HP Compaq Elite 8300 USDT as a dedicated Docker host for AI agents and automation. Running OpenClaw (AI agent platform) backed by an OpenAI Codex subscription, SearXNG as the web search backend, and a Discord integration for chat.
- **Why** — Dedicated node to experiment with AI agents, automate more, and keep agent workloads off other infrastructure.

---

## 2026-04-18 — Started documenting the homelab

- **What** — Created the `homelab/` directory with this changelog, an architecture overview, and a Mermaid diagram. The first step of the homelab is already in place: a Kubernetes cluster on Oracle Cloud's Always Free tier, driven by Claude Code through GitOps. From here on, every change that touches the homelab gets an entry.
- **Why** — Capturing the AI learning journey from the infrastructure side. Future-me (and anyone reading) should be able to see how the setup evolved, not just what it looks like today.
- **Links** — [`README.md`](README.md), cluster: [`../k8s-oci-cluster/`](../k8s-oci-cluster/), coding agent: [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview).
