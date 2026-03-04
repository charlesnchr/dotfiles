#!/usr/bin/env python3
"""
Agentic Slack Bot with Claude Agent SDK (Vertex AI)

A Claude Code-equipped Slack bot that can read, write, and search the codebase.
Automatically fetches recent Slack conversation context when invoked.

Environment Variables:
    SLACK_BOT_TOKEN              - Bot User OAuth Token (xoxb-...)
    SLACK_APP_TOKEN              - App-Level Token for Socket Mode (xapp-...)
    CLAUDE_CODE_USE_VERTEX       - Set to "1" for Vertex AI
    CLOUD_ML_REGION              - e.g., europe-west1
    ANTHROPIC_VERTEX_PROJECT_ID  - GCP project ID
    ANTHROPIC_MODEL              - Model to use (e.g., claude-sonnet-4-20250514)
    REPO_DIR                     - Path to the repo (defaults to this repo's root)
"""

import asyncio
import logging
import os
import re
from pathlib import Path

from claude_agent_sdk import (
    AssistantMessage,
    ClaudeAgentOptions,
    ResultMessage,
    TextBlock,
    query,
)
from slack_bolt.adapter.socket_mode.async_handler import AsyncSocketModeHandler
from slack_bolt.async_app import AsyncApp

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)

REPO_DIR = os.environ.get("REPO_DIR", str(Path(__file__).resolve().parent.parent))
HISTORY_LIMIT = 50
MAX_SLACK_MSG_LEN = 3900  # Slack limit is 4000, leave margin

app = AsyncApp(token=os.environ["SLACK_BOT_TOKEN"])

# Cache user ID -> display name
_user_cache: dict[str, str] = {}
_bot_user_id: str | None = None


async def get_bot_user_id(client) -> str:
    """Get the bot's own user ID to filter it from context."""
    global _bot_user_id
    if _bot_user_id is None:
        resp = await client.auth_test()
        _bot_user_id = resp["user_id"]
    return _bot_user_id


async def resolve_user(client, user_id: str) -> str:
    """Resolve a Slack user ID to a display name."""
    if user_id in _user_cache:
        return _user_cache[user_id]
    try:
        resp = await client.users_info(user=user_id)
        name = resp["user"]["profile"].get("display_name") or resp["user"]["real_name"] or user_id
        _user_cache[user_id] = name
    except Exception:
        _user_cache[user_id] = user_id
    return _user_cache[user_id]


async def fetch_context(client, channel: str, thread_ts: str | None) -> str:
    """Fetch recent Slack messages and format them as conversation context."""
    bot_id = await get_bot_user_id(client)

    try:
        if thread_ts:
            resp = await client.conversations_replies(channel=channel, ts=thread_ts, limit=HISTORY_LIMIT)
        else:
            resp = await client.conversations_history(channel=channel, limit=HISTORY_LIMIT)
    except Exception as e:
        logger.warning(f"Could not fetch history: {e}")
        return ""

    messages = resp.get("messages", [])
    # Chronological order
    messages = list(reversed(messages))

    lines = []
    for msg in messages:
        user_id = msg.get("user", "")
        if user_id == bot_id or msg.get("bot_id"):
            continue
        if msg.get("subtype"):
            continue
        text = msg.get("text", "").strip()
        if not text:
            continue
        name = await resolve_user(client, user_id)
        lines.append(f"[{name}]: {text}")

    return "\n".join(lines)


def markdown_to_slack(text: str) -> str:
    """Convert standard Markdown to Slack mrkdwn format."""
    # Protect code blocks from other transformations
    code_blocks: list[str] = []

    def stash_code_block(m: re.Match) -> str:
        code_blocks.append(m.group(2))
        return f"\x00CODEBLOCK{len(code_blocks) - 1}\x00"

    text = re.sub(r"```(\w+)?\n([\s\S]*?)```", stash_code_block, text)

    # Headers -> bold text
    text = re.sub(r"^#{1,6}\s+(.+)$", r"*\1*", text, flags=re.MULTILINE)
    # Bold: **text** or __text__ -> *text*
    text = re.sub(r"\*\*(.+?)\*\*", r"*\1*", text)
    text = re.sub(r"__(.+?)__", r"*\1*", text)
    # Strikethrough: ~~text~~ -> ~text~
    text = re.sub(r"~~(.+?)~~", r"~\1~", text)
    # Links: [text](url) -> <url|text>
    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r"<\2|\1>", text)
    # Images: ![alt](url) -> <url|alt> (best effort)
    text = re.sub(r"!\[([^\]]*)\]\(([^)]+)\)", r"<\2|\1>", text)

    # Restore code blocks (without language specifier)
    for i, block in enumerate(code_blocks):
        text = text.replace(f"\x00CODEBLOCK{i}\x00", f"```\n{block}```")

    return text


def clean_mention(text: str) -> str:
    """Remove the bot mention from the message text."""
    return re.sub(r"<@[A-Z0-9]+>\s*", "", text).strip()


def split_message(text: str, limit: int = MAX_SLACK_MSG_LEN) -> list[str]:
    """Split a long message into chunks that fit Slack's limit."""
    if len(text) <= limit:
        return [text]

    chunks = []
    while text:
        if len(text) <= limit:
            chunks.append(text)
            break
        # Try to split at a newline
        split_at = text.rfind("\n", 0, limit)
        if split_at == -1:
            split_at = limit
        chunks.append(text[:split_at])
        text = text[split_at:].lstrip("\n")
    return chunks


async def run_agent(prompt: str, context: str) -> str:
    """Run the Claude agent with full codebase access."""
    system_parts = [
        "You are CognitoBot, a coding assistant for the Cogito Forge team.",
        "You are NOT Claude Code. Do NOT identify yourself as Claude Code or mention what model you are.",
        "You are CognitoBot — a helpful, concise team assistant with full access to the codebase.",
        f"The codebase is at {REPO_DIR}.",
        "Keep responses concise and actionable.",
        "",
        "FORMATTING: Your output is posted to Slack. Use Slack mrkdwn, NOT Markdown:",
        "- Bold: *text* (not **text**)",
        "- Italic: _text_ (not *text*)",
        "- Strikethrough: ~text~",
        "- Code blocks: ```code``` (no language specifier after backticks)",
        "- Links: <url|text>",
        "- Bullet lists: use dash or bullet character",
    ]
    if context:
        system_parts.append(f"\nRecent conversation context from the Slack channel:\n{context}")

    system_prompt = "\n".join(system_parts)

    stderr_lines: list[str] = []

    def capture_stderr(line: str):
        stderr_lines.append(line)

    options = ClaudeAgentOptions(
        system_prompt=system_prompt,
        cwd=REPO_DIR,
        allowed_tools=["Read", "Write", "Edit", "Bash", "Glob", "Grep"],
        permission_mode="bypassPermissions",
        max_turns=25,
        setting_sources=[],  # Don't load project CLAUDE.md -- it's for developers, not this bot
        model=os.environ.get("ANTHROPIC_MODEL"),
        stderr=capture_stderr,
    )

    # Track the last assistant response (skip intermediate reasoning)
    last_assistant_texts: list[str] = []
    result_error: str | None = None
    model_logged = False
    try:
        async for message in query(prompt=prompt, options=options):
            if isinstance(message, AssistantMessage):
                if not model_logged:
                    logger.info(f"Agent using model: {message.model}")
                    model_logged = True
                texts = [block.text for block in message.content if isinstance(block, TextBlock) and block.text.strip()]
                if texts:
                    last_assistant_texts = texts
            elif isinstance(message, ResultMessage):
                logger.info(
                    f"Agent done: turns={message.num_turns} cost=${message.total_cost_usd} "
                    f"duration={message.duration_ms}ms"
                )
                if message.is_error and message.result:
                    result_error = message.result
    except Exception as e:
        logger.error(f"Agent error: {e}", exc_info=True)
        if stderr_lines:
            logger.error(f"Agent stderr (last 20 lines): {''.join(stderr_lines[-20:])}")
        if result_error:
            return f"Agent error: {result_error}"
        if not last_assistant_texts:
            return f"Sorry, I encountered an error: {e}"

    if result_error:
        return f"Agent error: {result_error}"

    return "\n\n".join(last_assistant_texts) or "I processed your request but have no text response."


async def handle_request(event: dict, say, client):
    """Handle an incoming message (mention or DM)."""
    channel = event["channel"]
    user = event["user"]
    ts = event["ts"]
    thread_ts = event.get("thread_ts")

    # Determine the text
    text = clean_mention(event.get("text", ""))
    if not text:
        await say(f"<@{user}> How can I help? Mention me with your question.", thread_ts=thread_ts or ts)
        return

    logger.info(f"Request from {user} in {channel}: {text[:100]}")

    # Add thinking reaction
    try:
        await client.reactions_add(channel=channel, timestamp=ts, name="thinking_face")
    except Exception:
        pass

    try:
        # Fetch conversation context
        context = await fetch_context(client, channel, thread_ts)

        # Run the agent
        response = await run_agent(text, context)
        response = markdown_to_slack(response)

        # Post response in thread
        reply_thread = thread_ts or ts
        for chunk in split_message(response):
            await say(chunk, thread_ts=reply_thread)

        # Success reaction
        try:
            await client.reactions_remove(channel=channel, timestamp=ts, name="thinking_face")
            await client.reactions_add(channel=channel, timestamp=ts, name="white_check_mark")
        except Exception:
            pass

    except Exception as e:
        logger.error(f"Error handling request: {e}", exc_info=True)
        try:
            await client.reactions_remove(channel=channel, timestamp=ts, name="thinking_face")
            await client.reactions_add(channel=channel, timestamp=ts, name="x")
        except Exception:
            pass
        await say(f"Sorry, something went wrong: {e}", thread_ts=thread_ts or ts)


@app.event("app_mention")
async def handle_mention(event, say, client):
    """Respond when the bot is @mentioned in a channel."""
    await handle_request(event, say, client)


@app.event("message")
async def handle_dm(event, say, client):
    """Respond to direct messages."""
    if event.get("channel_type") == "im" and "subtype" not in event:
        await handle_request(event, say, client)


async def main():
    """Start the bot."""
    print(f"Starting Claude Agent Slack Bot (repo: {REPO_DIR})...")
    handler = AsyncSocketModeHandler(app, os.environ["SLACK_APP_TOKEN"])
    await handler.start_async()


if __name__ == "__main__":
    asyncio.run(main())
