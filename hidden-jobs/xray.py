import json
import os
import re
from pathlib import Path

import requests
from litellm import completion

DEFAULT_MODEL = "gpt-4o-mini"


def generate_queries(job_description: str, model: str = DEFAULT_MODEL) -> list[dict]:
    """Use an LLM to generate Google X-Ray search queries for a job description."""
    xray_guide = Path(__file__).parent / "Google-X-Ray.md"
    system_context = xray_guide.read_text()

    response = completion(
        model=model,
        messages=[
            {
                "role": "system",
                "content": (
                    "You are an expert job sourcer. Use the following Google X-Ray "
                    "search guide to generate effective search queries.\n\n"
                    f"{system_context}\n\n"
                    "Given a job description, generate Google search queries that "
                    "find unlisted job postings.\n\n"
                    "CRITICAL RULES:\n"
                    "- Minimize the number of queries to save API credits\n"
                    "- Use ONE query per site/platform, packing multiple job title "
                    "variations with OR operators\n"
                    '  e.g. site:boards.greenhouse.io/* ("Senior DevOps Engineer" OR '
                    '"DevOps Lead" OR "SRE" OR "Platform Engineer" OR "Infrastructure Engineer")\n'
                    "- Cover these categories (one query each):\n"
                    "  1. Greenhouse ATS\n"
                    "  2. Ashby ATS\n"
                    "  3. Workable ATS\n"
                    "  4. Lever ATS\n"
                    "  5. Wildcard career pages (*.com/careers)\n"
                    "  6. Wildcard career pages (*.io/careers)\n"
                    "  7. Wildcard job pages (*.com/jobs)\n"
                    "- Include relevant title synonyms, seniority variations, and "
                    "related roles in each OR group\n"
                    "- Add remote/location filters from the job description if applicable\n\n"
                    "Return ONLY a JSON array of objects with keys: "
                    '"query", "category", "rationale".'
                ),
            },
            {"role": "user", "content": job_description},
        ],
        temperature=0.7,
    )

    text = response.choices[0].message.content.strip()
    # Strip markdown code fences if present
    text = re.sub(r"^```(?:json)?\s*", "", text)
    text = re.sub(r"\s*```$", "", text)
    return json.loads(text)


def _load_serper_keys() -> list[str]:
    """Load Serper API keys from SERPER_API_KEYS (comma-separated, supports multiple for rotation)."""
    keys_str = os.environ.get("SERPER_API_KEYS", "")
    keys = [k.strip() for k in keys_str.split(",") if k.strip()]
    if not keys:
        raise RuntimeError("Set SERPER_API_KEYS in .env (comma-separated for multiple keys)")
    return keys


_serper_keys: list[str] = []
_current_key_index: int = 0


def _get_serper_key() -> str:
    """Get the current Serper API key, initializing on first call."""
    global _serper_keys, _current_key_index
    if not _serper_keys:
        _serper_keys = _load_serper_keys()
        _current_key_index = 0
    return _serper_keys[_current_key_index]


def _rotate_serper_key() -> bool:
    """Rotate to the next Serper key. Returns False if no more keys available."""
    global _current_key_index
    _current_key_index += 1
    if _current_key_index >= len(_serper_keys):
        return False
    print(f"  Rotated to Serper key {_current_key_index + 1}/{len(_serper_keys)}")
    return True


def _serper_request(query: str, page: int = 1) -> list[dict] | None:
    """Single Serper API call. Returns results list, or None if all keys exhausted."""
    while True:
        api_key = _get_serper_key()
        payload = {"q": query}
        if page > 1:
            payload["page"] = page

        resp = requests.post(
            "https://google.serper.dev/search",
            headers={"X-API-KEY": api_key, "Content-Type": "application/json"},
            json=payload,
        )

        if resp.status_code in (403, 429):
            if _rotate_serper_key():
                continue
            print("  ⚠ All Serper API keys exhausted!")
            return None

        if resp.status_code == 400:
            print(f"  ⚠ Bad request: {resp.text}")
            return []

        resp.raise_for_status()
        data = resp.json()

        return [
            {
                "title": item.get("title", ""),
                "url": item.get("link", ""),
                "snippet": item.get("snippet", ""),
            }
            for item in data.get("organic", [])
        ]


def search_google(query: str, pages: int = 1) -> list[dict]:
    """Search Google via Serper. Each page returns ~10 results and costs 1 credit."""
    all_results = []
    for p in range(1, pages + 1):
        results = _serper_request(query, page=p)
        if results is None:
            break  # all keys exhausted
        all_results.extend(results)
        if len(results) < 10:
            break  # no more results available
    return all_results


def save_results(query_info: dict, results: list[dict], output_dir: str) -> str:
    """Save search results for one query as a markdown file."""
    os.makedirs(output_dir, exist_ok=True)

    # Build a safe filename from the category
    safe_name = re.sub(r"[^\w\s-]", "", query_info.get("category", "query")).strip()
    safe_name = re.sub(r"[\s]+", "-", safe_name).lower()
    # Avoid collisions by appending a short hash of the query
    suffix = abs(hash(query_info["query"])) % 10000
    filename = f"{safe_name}-{suffix}.md"
    filepath = os.path.join(output_dir, filename)

    lines = [
        f"# {query_info.get('category', 'Search Results')}",
        "",
        f"**Query:** `{query_info['query']}`",
        "",
        f"**Rationale:** {query_info.get('rationale', 'N/A')}",
        "",
        f"**Results:** {len(results)}",
        "",
        "---",
        "",
    ]

    if not results:
        lines.append("_No results found._")
    else:
        for i, r in enumerate(results, 1):
            lines.append(f"{i}. **[{r['title']}]({r['url']})**")
            if r.get("snippet"):
                lines.append(f"   {r['snippet']}")
            lines.append("")

    Path(filepath).write_text("\n".join(lines))
    return filepath
