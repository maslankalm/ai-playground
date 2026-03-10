# Hidden Jobs

## Goal

Find job positions that are **not listed on traditional job boards**. Many roles are filled through company career pages, internal ATS platforms, and other non-obvious channels that most job seekers never check.

## Background

This project was inspired by a book on job searching where the author highlights that the best opportunities often come from sources beyond the usual job boards. The idea is simple: if most candidates compete on LinkedIn and Indeed, going directly to the source gives you an edge.

I decided to automate this approach using AI. The first step was to use [NotebookLM](https://notebooklm.google.com/) to process the ebook — feeding it as a source and extracting actionable tips into structured markdown files. These files then serve as instructions and reference material for Claude Code to help execute the strategies.

## Setup

```bash
cd hidden-jobs
pip install -r requirements.txt
```

Create a `.env` file (see `.env.example`):

```
OPENAI_API_KEY=sk-...
SERPER_API_KEYS=your-key-here
```

Get a free Serper API key at https://serper.dev (2,500 free queries per key). Supports multiple comma-separated keys — auto-rotates when credits run out.

## Usage

```bash
# From a text file
python main.py --file jd.txt

# Inline description
python main.py --text "Senior DevOps Engineer with Kubernetes experience, remote"

# From stdin
cat jd.txt | python main.py

# More pages per query (default 1, ~10 results each, 1 credit per page)
python main.py --text "DevOps Engineer" --pages 3

# Use a different LLM
python main.py --text "DevOps Engineer" --model claude-sonnet-4-20250514
```

Results are saved as markdown files in the `results/` directory (one per query).

## How It Works

1. Your job description is sent to an LLM (default: gpt-4o-mini, configurable via `--model`) along with the X-Ray search guide
2. The LLM generates targeted Google search queries covering ATS platforms, wildcard career pages, and Boolean combinations
3. Each query is executed via Serper.dev (Google Search API) with automatic key rotation
4. Results are saved as individual markdown files grouped by query category

## Contents

- **[Google-X-Ray.md](Google-X-Ray.md)** — Techniques for using Google's `site:` operator and Boolean logic to find unlisted jobs directly on company websites and ATS platforms. Loaded at runtime into the LLM prompt — edit this file to refine search strategies without touching code.
