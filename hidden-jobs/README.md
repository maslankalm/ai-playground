# Hidden Jobs

## Goal

Find job positions that are **not listed on traditional job boards**. Many roles are filled through company career pages, internal ATS platforms, and other non-obvious channels that most job seekers never check.

## Background

This project was inspired by a book on job searching where the author highlights that the best opportunities often come from sources beyond the usual job boards. The idea is simple: if most candidates compete on LinkedIn and Indeed, going directly to the source gives you an edge.

I decided to automate this approach using AI. The first step was to use [NotebookLM](https://notebooklm.google.com/) to process the ebook — feeding it as a source and extracting actionable tips into structured markdown files. These files then serve as instructions and reference material for Claude Code to help execute the strategies.

## Contents

- **[Google-X-Ray.md](Google-X-Ray.md)** — Techniques for using Google's `site:` operator and Boolean logic to find unlisted jobs directly on company websites and ATS platforms.
