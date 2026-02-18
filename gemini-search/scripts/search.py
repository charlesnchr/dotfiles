"""Web search using Pydantic AI with Gemini 2.5 Flash on Vertex AI."""

import argparse
import asyncio
import json
import sys

import httpx
from pydantic_ai import Agent
from pydantic_ai.builtin_tools import WebSearchTool
from pydantic_ai.messages import BuiltinToolReturnPart
from pydantic_ai.models.google import GoogleModel
from pydantic_ai.providers.google import GoogleProvider


async def resolve_url(redirect_url: str) -> str:
    """Resolve Vertex AI grounding redirect to actual URL."""
    try:
        async with httpx.AsyncClient(follow_redirects=False) as client:
            response = await client.head(redirect_url, timeout=5.0)
            if response.status_code in (301, 302, 303, 307, 308):
                return response.headers.get("location", redirect_url)
            return redirect_url
    except Exception:
        return redirect_url


async def web_search(query: str) -> dict:
    """Search the web using Gemini with grounding."""
    import google.auth

    _, project_id = google.auth.default()

    if not project_id:
        raise ValueError(
            "No GCP project found. Run: gcloud config set project YOUR_PROJECT_ID"
        )

    provider = GoogleProvider(
        vertexai=True,
        project=project_id,
        location="us-central1",
    )

    model = GoogleModel("gemini-2.5-flash", provider=provider)
    agent = Agent(model=model, builtin_tools=[WebSearchTool()])

    result = await agent.run(query)

    sources = []
    for msg in result.all_messages():
        if hasattr(msg, "parts"):
            for part in msg.parts:
                if (
                    isinstance(part, BuiltinToolReturnPart)
                    and part.tool_name == "web_search"
                ):
                    if isinstance(part.content, list):
                        for source in part.content:
                            redirect_url = source.get("uri", "")
                            actual_url = await resolve_url(redirect_url)
                            sources.append(
                                {
                                    "domain": source.get("domain"),
                                    "title": source.get("title"),
                                    "url": actual_url,
                                }
                            )

    return {"response": result.output, "sources": sources}


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("query", help="The search query")
    parser.add_argument("--json", action="store_true", help="JSON output")
    args = parser.parse_args()

    try:
        result = await web_search(args.query)
        if args.json:
            print(json.dumps(result, indent=2))
        else:
            print(f"\nRESPONSE:\n{result['response']}\n")
            print(f"SOURCES ({len(result['sources'])}):")
            for i, source in enumerate(result["sources"], 1):
                print(f"{i}. {source['domain']} - {source['url']}")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
