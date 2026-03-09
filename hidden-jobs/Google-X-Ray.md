# Google X-Ray Search Instruction for Remote Job Sourcing

This guide explains how to use the **`site:` operator** (X-Ray Search) and **Boolean logic** to find unlisted or remote job opportunities directly on company websites and international applicant tracking systems (ATS).

### 1. The Core Syntax: `site:` Operator
The `site:` operator limits Google search results to a specific domain or path.
*   **Formula:** `site:[domain] "[job title]"`
*   **Targeting a specific company:** `site:google.com "careers"` or `site:example.com ("jobs" OR "careers" OR "hiring")`.

### 2. Using the Wildcard (`*`)
The asterisk replaces any word in a URL, allowing you to search thousands of company career pages simultaneously.
*   **Broad Career Page Search:**
    *   `site:*.io/careers "DevOps"`
    *   `site:*.com/jobs "Remote"`
    *   `site:*.ai/careers "SRE"`

### 3. Boolean Search Logic
Combine these operators to refine your results and ensure you only find relevant roles.
*   **`""` (Quotes):** Forces an exact phrase match (e.g., `"Senior DevOps Engineer"`).
*   **`OR`:** Searches for multiple variations of a title (e.g., `"SRE" OR "DevOps"`).
*   **`AND` (or space):** Ensures all terms appear in the result (e.g., `DevOps Remote`).
*   **`-` (Minus/NOT):** Excludes unwanted terms (e.g., `DevOps -Senior` to find junior/mid roles).
*   **`()` (Parentheses):** Groups logic (e.g., `("SRE" OR "DevOps") AND ("Remote" OR "Worldwide")`).

### 4. Targeting Specific Markets
To find remote roles in specific regions, use **country-specific domain codes**.
*   **United Kingdom:** `site:*.uk/careers "remote" "DevOps"`
*   **Italy:** `site:*.it/careers "Python Developer" remote`
*   **Germany:** `site:*.de/jobs "SRE" remote`
*   **Sweden:** `site:se.linkedin.com/jobs "business analyst" remote`

### 5. Searching Global ATS Platforms
Many international startups host jobs on third-party platforms. You can "X-Ray" these databases directly:
*   **Greenhouse (US/Global):** `site:boards.greenhouse.io/* "DevOps" remote`
*   **Ashby (UK/Global):** `site:jobs.ashbyhq.com/* "remote" "Senior"`
*   **Notion (Startups/Web3):** `site:*.notion.site ("careers" OR "join us") "DevOps"`
*   **Workable:** `site:apply.workable.com/* [position]`
*   **Lever:** `site:jobs.eu.lever.co [position]`

### 6. Pro-Tip: "Three Stars" Trick
To capture varied phrasing in job titles, use triple wildcards.
*   **Example:** `site:*.com/careers "specialist * * *"`
