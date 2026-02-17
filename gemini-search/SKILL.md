---
name: web-search
description: Web search instructions and scripts using Pydantic AI with Gemini 2.5 Flash on Vertex AI.
---

## Scripts

**Search the web:**
```bash
uv run python ~/.claude/skills/web-search/scripts/search.py "search query"
```

**Fetch a specific URL:**
```bash
uv run python ~/.claude/skills/web-search/scripts/fetch.py "https://example.com"
```

## Research Process

### Step 1: Search (up to 3 rounds)

Run searches using the search script. Do as many rounds as needed to get a comprehensive answer, but **maximum 3 searches**.

- Round 1: Broad initial search
- Round 2 (if needed): Refined query based on gaps or new angles discovered
- Round 3 (if needed): Final targeted search for remaining questions

Stop earlier if you have enough information.

### Step 2: Fetch (required)

After completing your searches, review the sources returned. **Always fetch at least 1-2 of the most relevant links** to get full content. Prioritize:
- Official documentation
- GitHub READMEs
- Authoritative articles or blog posts

Fetch more if needed to resolve conflicts or fill gaps.

## Output

Provide a comprehensive answer with:
- Key findings
- Links to the most useful sources
- Any conflicting information found

## Troubleshooting

If authentication fails:
```bash
gcloud auth application-default login
```
