# Hidden Jobs

## Goal

Find job positions that are **not listed on traditional job boards**. Many roles are filled through company career pages, internal ATS platforms, and other non-obvious channels that most job seekers never check.

Instead of manually crafting Google X-Ray searches, an LLM reads the [search techniques guide](Google-X-Ray.md) and your job description, then generates optimized Boolean queries targeting ATS platforms and company career pages. Any LLM provider works via [LiteLLM](https://docs.litellm.ai/) (OpenAI, Anthropic, Google, or local models via Ollama).

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

# Use a local model via Ollama (free, no API key needed)
python main.py --text "DevOps Engineer" --model ollama/qwen3:14b
```

Results are saved as markdown files in the `results/` directory (one per query).

> [!TIP]
> **Reviewing results with Obsidian** — [Obsidian](https://obsidian.md/) is great for browsing the generated markdown files — just open `results/` as a vault.

![Results viewed in Obsidian](obsidian.png)
