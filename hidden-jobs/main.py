#!/usr/bin/env python3
"""CLI tool to find hidden job postings using Google X-Ray searches."""

import argparse
import os
import re
import sys
from datetime import datetime

from dotenv import load_dotenv

from xray import generate_queries, save_results, search_google


def read_job_description(args) -> str:
    if args.file:
        return open(args.file).read().strip()
    if args.text:
        return args.text.strip()
    if not sys.stdin.isatty():
        return sys.stdin.read().strip()
    print("Error: provide a job description via --file, --text, or stdin.")
    sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Find hidden job postings with Google X-Ray searches"
    )
    parser.add_argument("--file", "-f", help="Path to a job description text file")
    parser.add_argument("--text", "-t", help="Job description as a string")
    parser.add_argument(
        "--output-dir", "-o", default="./results", help="Output directory (default: ./results)"
    )
    parser.add_argument(
        "--pages", "-p", type=int, default=1,
        help="Pages per query, ~10 results each, 1 credit per page (default: 1)"
    )
    parser.add_argument(
        "--model", "-m", default="gpt-4o-mini", help="LLM model to use (default: gpt-4o-mini)"
    )
    args = parser.parse_args()

    load_dotenv()

    jd = read_job_description(args)
    print(f"Job description ({len(jd)} chars) loaded.\n")

    # Build unique output directory: results/YYYYMMDD-HHMMSS-keywords
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    words = re.findall(r"[a-zA-Z]+", jd)
    keywords = "-".join(w.lower() for w in words[:5])
    run_dir = os.path.join(args.output_dir, f"{timestamp}-{keywords}")

    print(f"Generating X-Ray search queries using {args.model}...")
    queries = generate_queries(jd, model=args.model)
    print(f"Generated {len(queries)} queries:\n")
    for i, q in enumerate(queries, 1):
        print(f"  {i}. [{q.get('category', '')}] {q['query']}")
    print()

    saved_files = []
    for i, q in enumerate(queries, 1):
        print(f"[{i}/{len(queries)}] Searching: {q['query']}")
        results = search_google(q["query"], pages=args.pages)
        filepath = save_results(q, results, run_dir)
        saved_files.append(filepath)
        print(f"  → {len(results)} results saved to {filepath}")

    print(f"\nDone! {len(saved_files)} files saved to {run_dir}/")


if __name__ == "__main__":
    main()
