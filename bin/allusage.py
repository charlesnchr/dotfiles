#!/usr/bin/env python3
"""Unified usage reporting for OpenClaw (JSONL) and OpenCode (SQLite),
with optional plotting across all three sources including Claude Code."""

import json
import os
import sys
import glob
import sqlite3
from datetime import datetime, date
from collections import defaultdict

# ── Args ──────────────────────────────────────────────────────────────────────
group_mode = "daily"
show_breakdown = False
show_plot = False
source_filter = set()  # empty = show all

SOURCE_ALIASES = {
    "openclaw": "openclaw",
    "oc": "openclaw",
    "claw": "openclaw",
    "opencode": "opencode",
    "oe": "opencode",
    "code": "opencode",
    "openwhispr": "openwhispr",
    "ow": "openwhispr",
    "whispr": "openwhispr",
    "whisper": "openwhispr",
    "claude": "claude",
    "cc": "claude",
    "claudecode": "claude",
}

for arg in sys.argv[1:]:
    if arg in ("daily", "weekly", "monthly", "session"):
        group_mode = arg
    elif arg in ("-b", "--breakdown"):
        show_breakdown = True
    elif arg in ("-p", "--plot"):
        show_plot = True
    elif arg.lower() in SOURCE_ALIASES:
        source_filter.add(SOURCE_ALIASES[arg.lower()])


def should_show(source_name):
    return not source_filter or source_name in source_filter


# ── ANSI ──────────────────────────────────────────────────────────────────────
DIM = "\033[90m"
CYAN = "\033[36m"
RESET = "\033[39m"


# ── Helpers ───────────────────────────────────────────────────────────────────
def fmt_num(n):
    return f"{int(n):,}"


def fmt_cost(c):
    return f"${c:.2f}"


def fmt_model(name, provider):
    return f"{name} ({provider})" if provider else str(name)


def to_period(dt_obj, mode):
    if mode == "daily":
        return dt_obj.strftime("%Y-%m-%d")
    elif mode == "monthly":
        return dt_obj.strftime("%Y-%m")
    elif mode == "weekly":
        y, w, _ = dt_obj.isocalendar()
        return f"{y}-W{w:02d}"
    return dt_obj.strftime("%Y-%m-%d")


def print_table(title, usage_by_period, totals, mode, breakdown, col_labels=None):
    """Render a dynamic-width table to stdout."""
    if not usage_by_period:
        print(f"\n{title}: no data found.")
        return

    sorted_periods = sorted(usage_by_period.keys())
    entries = []

    for period in sorted_periods:
        parts = period.split("-")
        year = parts[0]
        month_day = ""
        if mode == "daily":
            month_day = f"{parts[1]}-{parts[2]}" if len(parts) == 3 else ""
        elif mode in ("monthly", "weekly"):
            month_day = parts[1] if len(parts) > 1 else ""

        models = sorted(usage_by_period[period].keys())

        if not breakdown and len(models) > 1:
            p = {
                k: sum(usage_by_period[period][m][k] for m in models)
                for k in ("input", "output", "cacheRd", "cacheWr", "total", "cost")
            }
            entries.append(
                {
                    "type": "data",
                    "date": year,
                    "model": f"- Multiple ({len(models)})",
                    "input": fmt_num(p["input"]),
                    "output": fmt_num(p["output"]),
                    "cache_wr": fmt_num(p["cacheWr"]),
                    "cache_rd": fmt_num(p["cacheRd"]),
                    "total": fmt_num(p["total"]),
                    "cost": fmt_cost(p["cost"]),
                }
            )
            if month_day:
                entries.append({"type": "date_cont", "date": month_day})
            entries.append({"type": "sep"})

        elif breakdown and len(models) > 1:
            p = {
                k: sum(usage_by_period[period][m][k] for m in models)
                for k in ("input", "output", "cacheRd", "cacheWr", "total", "cost")
            }
            entries.append(
                {
                    "type": "data",
                    "date": year,
                    "model": "",
                    "input": fmt_num(p["input"]),
                    "output": fmt_num(p["output"]),
                    "cache_wr": fmt_num(p["cacheWr"]),
                    "cache_rd": fmt_num(p["cacheRd"]),
                    "total": fmt_num(p["total"]),
                    "cost": fmt_cost(p["cost"]),
                }
            )
            if month_day:
                entries.append({"type": "date_cont", "date": month_day})
            entries.append({"type": "sep"})
            for idx, mn in enumerate(models):
                u = usage_by_period[period][mn]
                entries.append(
                    {
                        "type": "data",
                        "date": f"  {'└─' if idx == len(models) - 1 else '├─'}",
                        "model": fmt_model(mn, u["provider"]),
                        "input": fmt_num(u["input"]),
                        "output": fmt_num(u["output"]),
                        "cache_wr": fmt_num(u["cacheWr"]),
                        "cache_rd": fmt_num(u["cacheRd"]),
                        "total": fmt_num(u["total"]),
                        "cost": fmt_cost(u["cost"]),
                    }
                )
            entries.append({"type": "sep"})
        else:
            mn = models[0]
            u = usage_by_period[period][mn]
            entries.append(
                {
                    "type": "data",
                    "date": year,
                    "model": f"- {fmt_model(mn, u['provider'])}",
                    "input": fmt_num(u["input"]),
                    "output": fmt_num(u["output"]),
                    "cache_wr": fmt_num(u["cacheWr"]),
                    "cache_rd": fmt_num(u["cacheRd"]),
                    "total": fmt_num(u["total"]),
                    "cost": fmt_cost(u["cost"]),
                }
            )
            if month_day:
                entries.append({"type": "date_cont", "date": month_day})
            entries.append({"type": "sep"})

    total_row = {
        "date": "Total",
        "model": "",
        "input": fmt_num(totals["input"]),
        "output": fmt_num(totals["output"]),
        "cache_wr": fmt_num(totals["cacheWr"]),
        "cache_rd": fmt_num(totals["cacheRd"]),
        "total": fmt_num(totals["total"]),
        "cost": fmt_cost(totals["cost"]),
    }

    all_data = [e for e in entries if e["type"] == "data"] + [total_row]
    all_dates = [e for e in entries if e["type"] in ("data", "date_cont")]

    dw = max(9, max((len(e["date"]) for e in all_dates), default=9))
    mw = max(20, max((len(e["model"]) for e in all_data), default=20))
    iw = max(len("Input"), max(len(e["input"]) for e in all_data))
    ow = max(len("Output"), max(len(e["output"]) for e in all_data))
    cww = max(len("Create"), max(len(e["cache_wr"]) for e in all_data))
    crw = max(len("Read"), max(len(e["cache_rd"]) for e in all_data))
    tw = max(len("Tokens"), max(len(e["total"]) for e in all_data))
    cow = max(len("(USD)"), max(len(e["cost"]) for e in all_data))

    def hl(l, m, r):
        s = [f"{'─' * (w + 2)}" for w in (dw, mw, iw, ow, cww, crw, tw, cow)]
        return f"{DIM}{l}{m.join(s)}{r}{RESET}"

    def rl(d, m, i, o, cw, cr, t, c, color=""):
        ec = RESET if color else ""
        return (
            f"{DIM}│{RESET}{color} {d.ljust(dw)} {ec}"
            f"{DIM}│{RESET}{color} {m.ljust(mw)} {ec}"
            f"{DIM}│{RESET}{color} {i.rjust(iw)} {ec}"
            f"{DIM}│{RESET}{color} {o.rjust(ow)} {ec}"
            f"{DIM}│{RESET}{color} {cw.rjust(cww)} {ec}"
            f"{DIM}│{RESET}{color} {cr.rjust(crw)} {ec}"
            f"{DIM}│{RESET}{color} {t.rjust(tw)} {ec}"
            f"{DIM}│{RESET}{color} {c.rjust(cow)} {ec}{DIM}│{RESET}"
        )

    col1 = {"weekly": "Week", "monthly": "Month"}.get(mode, "Date")
    lb = col_labels or {}
    h_input = lb.get("input", "Input")
    h_col5 = lb.get("col5", "Cache")
    h_col5_sub = lb.get("col5_sub", "Create")
    h_col6 = lb.get("col6", "Cache")
    h_col6_sub = lb.get("col6_sub", "Read")
    print(f"\n{title}")
    print(f"\n{hl('┌', '┬', '┐')}")
    print(rl(col1, "Models", h_input, "Output", h_col5, h_col6, "Total", "Cost", CYAN))
    print(rl("", "", "", "", h_col5_sub, h_col6_sub, "Tokens", "(USD)", CYAN))
    print(hl("├", "┼", "┤"))

    for e in entries:
        if e["type"] == "sep":
            print(hl("├", "┼", "┤"))
        elif e["type"] == "date_cont":
            print(rl(e["date"], "", "", "", "", "", "", ""))
        elif e["type"] == "data":
            print(
                rl(
                    e["date"],
                    e["model"],
                    e["input"],
                    e["output"],
                    e["cache_wr"],
                    e["cache_rd"],
                    e["total"],
                    e["cost"],
                )
            )

    print(
        rl(
            total_row["date"],
            total_row["model"],
            total_row["input"],
            total_row["output"],
            total_row["cache_wr"],
            total_row["cache_rd"],
            total_row["total"],
            total_row["cost"],
        )
    )
    print(hl("└", "┴", "┘"))


def add_usage(store, period, model, provider, inp, out, crd, cwr, tot, cost):
    if period not in store:
        store[period] = {}
    if model not in store[period]:
        store[period][model] = {
            "input": 0,
            "output": 0,
            "cacheRd": 0,
            "cacheWr": 0,
            "total": 0,
            "cost": 0.0,
            "provider": provider,
        }
    d = store[period][model]
    d["input"] += inp
    d["output"] += out
    d["cacheRd"] += crd
    d["cacheWr"] += cwr
    d["total"] += tot
    d["cost"] += cost


# ── Collect OpenClaw data ─────────────────────────────────────────────────────
oc_usage = {}
oc_totals = {"input": 0, "output": 0, "cacheRd": 0, "cacheWr": 0, "total": 0, "cost": 0}
# For plots: daily {cost, input, output}
oc_daily = defaultdict(lambda: {"cost": 0, "input": 0, "output": 0})

for fpath in glob.glob(os.path.expanduser("~/.openclaw/agents/*/sessions/*.jsonl")):
    for line in open(fpath):
        line = line.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
        except json.JSONDecodeError:
            continue
        if obj.get("type") != "message":
            continue
        msg = obj.get("message", {})
        if msg.get("role") != "assistant":
            continue
        usage = msg.get("usage", {})
        if not usage.get("totalTokens", 0):
            continue

        inp = usage.get("input", 0) or 0
        out = usage.get("output", 0) or 0
        crd = usage.get("cacheRead", 0) or 0
        cwr = usage.get("cacheWrite", 0) or 0
        tot = usage.get("totalTokens", 0) or 0
        cost_obj = usage.get("cost", {})
        cost = (
            (cost_obj.get("total", 0) or 0)
            if isinstance(cost_obj, dict)
            else (cost_obj or 0)
        )
        provider = msg.get("provider", "") or ""
        model = msg.get("model", "") or ""
        ts = obj.get("timestamp", "")
        try:
            dt = datetime.fromisoformat(ts.replace("Z", "+00:00"))
        except (ValueError, AttributeError):
            continue

        period = to_period(dt, group_mode)
        add_usage(oc_usage, period, model, provider, inp, out, crd, cwr, tot, cost)
        for k in ("input", "output", "cacheRd", "cacheWr", "total", "cost"):
            oc_totals[k] += {
                "input": inp,
                "output": out,
                "cacheRd": crd,
                "cacheWr": cwr,
                "total": tot,
                "cost": cost,
            }[k]

        d = dt.date()
        oc_daily[d]["cost"] += cost
        oc_daily[d]["input"] += inp
        oc_daily[d]["output"] += out

# ── Collect OpenCode data ─────────────────────────────────────────────────────
oe_usage = {}
oe_totals = {"input": 0, "output": 0, "cacheRd": 0, "cacheWr": 0, "total": 0, "cost": 0}
oe_daily = defaultdict(lambda: {"cost": 0, "input": 0, "output": 0})

db_path = os.path.expanduser("~/.local/share/opencode/opencode.db")
if os.path.exists(db_path):
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        cursor.execute("""
            SELECT
                time_created,
                json_extract(data, '$.modelID') as model,
                json_extract(data, '$.providerID') as provider,
                SUM(json_extract(data, '$.tokens.input')) as inp,
                SUM(json_extract(data, '$.tokens.output')) as out,
                SUM(json_extract(data, '$.tokens.cache.read')) as crd,
                SUM(json_extract(data, '$.tokens.cache.write')) as cwr,
                SUM(json_extract(data, '$.tokens.total')) as tot,
                SUM(json_extract(data, '$.cost')) as cost
            FROM message
            WHERE json_extract(data, '$.tokens.total') > 0
              AND json_extract(data, '$.role') = 'assistant'
            GROUP BY time_created, json_extract(data, '$.modelID')
            ORDER BY time_created
        """)
        for row in cursor.fetchall():
            ts, model, provider, inp, out, crd, cwr, tot, cost = row
            inp = inp or 0
            out = out or 0
            crd = crd or 0
            cwr = cwr or 0
            tot = tot or 0
            cost = cost or 0
            provider = provider or ""
            dt = datetime.fromtimestamp(ts / 1000.0)
            period = to_period(dt, group_mode)
            add_usage(oe_usage, period, model, provider, inp, out, crd, cwr, tot, cost)
            for k in ("input", "output", "cacheRd", "cacheWr", "total", "cost"):
                oe_totals[k] += {
                    "input": inp,
                    "output": out,
                    "cacheRd": crd,
                    "cacheWr": cwr,
                    "total": tot,
                    "cost": cost,
                }[k]
            d = dt.date()
            oe_daily[d]["cost"] += cost
            oe_daily[d]["input"] += inp
            oe_daily[d]["output"] += out
        conn.close()
    except Exception as e:
        print(f"Error accessing OpenCode SQLite DB: {e}")

# ── Collect OpenWhispr data ────────────────────────────────────────────────────
ow_usage = {}
ow_totals = {"input": 0, "output": 0, "cacheRd": 0, "cacheWr": 0, "total": 0, "cost": 0}
ow_daily = defaultdict(lambda: {"cost": 0, "input": 0, "output": 0})

# Pricing: per 1M tokens for token-based models, per hour for duration-based models
WHISPR_TOKEN_PRICING = {
    "gpt-4o-transcribe": {"audio_input": 6.00, "output": 10.00},
    "gpt-4o-mini-transcribe": {"audio_input": 3.00, "output": 5.00},
    "whisper-1": {"audio_input": 6.00, "output": 0.00},
}
WHISPR_HOURLY_PRICING = {
    "whisper-large-v3": 0.111,
    "whisper-large-v3-turbo": 0.04,
}

ow_db_path = os.path.expanduser(
    "~/Library/Application Support/open-whispr/transcriptions.db"
)
if os.path.exists(ow_db_path):
    try:
        conn = sqlite3.connect(ow_db_path)
        cursor = conn.cursor()
        # Check if table exists
        cursor.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='transcription_usage'"
        )
        if cursor.fetchone():
            # Check if duration_seconds column exists
            cursor.execute("PRAGMA table_info(transcription_usage)")
            columns = [col[1] for col in cursor.fetchall()]
            has_duration = "duration_seconds" in columns

            if has_duration:
                cursor.execute("""
                    SELECT created_at, model, provider, input_tokens, output_tokens,
                           audio_tokens, total_tokens, duration_seconds
                    FROM transcription_usage
                    ORDER BY created_at
                """)
            else:
                cursor.execute("""
                    SELECT created_at, model, provider, input_tokens, output_tokens,
                           audio_tokens, total_tokens, 0 as duration_seconds
                    FROM transcription_usage
                    ORDER BY created_at
                """)
            for row in cursor.fetchall():
                ts_str, model, provider, inp, out, audio, tot, dur = row
                inp = inp or 0
                out = out or 0
                audio = audio or 0
                tot = tot or 0
                dur = dur or 0
                provider = provider or ""
                model = model or ""
                try:
                    dt = datetime.fromisoformat(ts_str.replace("Z", "+00:00"))
                except (ValueError, AttributeError):
                    try:
                        dt = datetime.strptime(ts_str, "%Y-%m-%d %H:%M:%S")
                    except (ValueError, AttributeError):
                        continue

                # Estimate cost: token-based for OpenAI/Azure, hourly for Groq
                hourly = WHISPR_HOURLY_PRICING.get(model)
                if hourly and dur > 0:
                    # Groq bills minimum 10s per request
                    billed_seconds = max(dur, 10)
                    cost = (billed_seconds / 3600) * hourly
                else:
                    pricing = WHISPR_TOKEN_PRICING.get(
                        model, {"audio_input": 6.00, "output": 10.00}
                    )
                    cost = (
                        audio * pricing["audio_input"] + out * pricing["output"]
                    ) / 1_000_000

                period = to_period(dt, group_mode)
                # For display: audio_tokens for token-based, duration (as seconds) for hourly
                display_input = audio if audio > 0 else round(dur)
                add_usage(
                    ow_usage,
                    period,
                    model,
                    provider,
                    display_input,
                    out,
                    0,
                    0,
                    tot,
                    cost,
                )
                for k in ("input", "output", "cacheRd", "cacheWr", "total", "cost"):
                    ow_totals[k] += {
                        "input": display_input,
                        "output": out,
                        "cacheRd": 0,
                        "cacheWr": 0,
                        "total": tot,
                        "cost": cost,
                    }[k]
                d = dt.date()
                ow_daily[d]["cost"] += cost
                ow_daily[d]["input"] += display_input
                ow_daily[d]["output"] += out
        conn.close()
    except Exception as e:
        print(f"Error accessing OpenWhispr SQLite DB: {e}")

# ── Print tables ──────────────────────────────────────────────────────────────
mode_title = group_mode.capitalize()
if should_show("openclaw"):
    print_table(
        f"📊 OpenClaw Token Usage Report - {mode_title} (From JSONL Sessions)",
        oc_usage,
        oc_totals,
        group_mode,
        show_breakdown,
    )
if should_show("opencode"):
    print_table(
        f"📊 OpenCode Token Usage Report - {mode_title} (From SQLite DB)",
        oe_usage,
        oe_totals,
        group_mode,
        show_breakdown,
    )
if should_show("openwhispr"):
    print_table(
        f"📊 OpenWhispr Token Usage Report - {mode_title} (From SQLite DB)",
        ow_usage,
        ow_totals,
        group_mode,
        show_breakdown,
        col_labels={
            "input": "Audio",
            "col5": "",
            "col5_sub": "",
            "col6": "",
            "col6_sub": "",
        },
    )

# ── Plotting ──────────────────────────────────────────────────────────────────
if not show_plot:
    sys.exit(0)

import urllib.request
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

# Fetch litellm pricing for Claude Code cost calculation
LITELLM_URL = "https://raw.githubusercontent.com/BerriAI/litellm/main/model_prices_and_context_window.json"
try:
    with urllib.request.urlopen(LITELLM_URL, timeout=10) as resp:
        _litellm = json.loads(resp.read())
except Exception:
    _litellm = {}


def _get_pricing(model_name):
    for prefix in ("claude-", "anthropic.claude-", ""):
        key = prefix + model_name.replace("claude-", "") if prefix else model_name
        if key in _litellm:
            p = _litellm[key]
            return {
                k: p.get(v, 0) or 0
                for k, v in (
                    ("input", "input_cost_per_token"),
                    ("output", "output_cost_per_token"),
                    ("cache_write", "cache_creation_input_token_cost"),
                    ("cache_read", "cache_read_input_token_cost"),
                )
            }
    for key, p in _litellm.items():
        if model_name in key and not key.startswith(("au.", "eu.", "us.")):
            if p.get("input_cost_per_token"):
                return {
                    k: p.get(v, 0) or 0
                    for k, v in (
                        ("input", "input_cost_per_token"),
                        ("output", "output_cost_per_token"),
                        ("cache_write", "cache_creation_input_token_cost"),
                        ("cache_read", "cache_read_input_token_cost"),
                    )
                }
    return None


# Collect Claude Code daily data (for plots only — ccusage handles its table)
cc_daily = defaultdict(lambda: {"cost": 0, "input": 0, "output": 0})
seen_hashes = set()
for f in glob.glob(os.path.expanduser("~/.claude/projects/*/") + "*.jsonl"):
    for line in open(f):
        line = line.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
        except json.JSONDecodeError:
            continue
        if obj.get("type") != "assistant":
            continue
        msg = obj.get("message", {})
        usage = msg.get("usage", {})
        model = msg.get("model", "")
        ts = obj.get("timestamp", "")
        if not ts or not usage.get("input_tokens"):
            continue
        msg_id = msg.get("id", "")
        req_id = obj.get("requestId", "")
        if msg_id and req_id:
            h = f"{msg_id}:{req_id}"
            if h in seen_hashes:
                continue
            seen_hashes.add(h)
        try:
            d = datetime.fromisoformat(ts.replace("Z", "+00:00")).date()
        except (ValueError, AttributeError):
            continue
        inp = usage.get("input_tokens", 0) or 0
        out = usage.get("output_tokens", 0) or 0
        cw = usage.get("cache_creation_input_tokens", 0) or 0
        cr = usage.get("cache_read_input_tokens", 0) or 0
        p = _get_pricing(model)
        cost = (
            (
                inp * p["input"]
                + out * p["output"]
                + cw * p["cache_write"]
                + cr * p["cache_read"]
            )
            if p
            else 0
        )
        cc_daily[d]["cost"] += cost
        cc_daily[d]["input"] += inp + cw + cr  # total input-side tokens
        cc_daily[d]["output"] += out

# Build date range
all_dates = (
    set(cc_daily.keys())
    | set(oc_daily.keys())
    | set(oe_daily.keys())
    | set(ow_daily.keys())
)
if not all_dates:
    print("No plot data found.")
    sys.exit(0)

date_range = []
d = min(all_dates)
while d <= max(all_dates):
    date_range.append(d)
    d = date.fromordinal(d.toordinal() + 1)

sources = {
    "Claude Code": (cc_daily, "#E07A5F"),
    "OpenClaw": (oc_daily, "#3D85C6"),
    "OpenCode": (oe_daily, "#81B29A"),
    "OpenWhispr": (ow_daily, "#D4A843"),
}

plt.style.use("seaborn-v0_8-darkgrid")

metrics = [
    ("cost", "Cost (USD)", lambda v: f"${v:,.2f}"),
    ("input", "Input Tokens", lambda v: f"{v:,.0f}"),
    ("output", "Output Tokens", lambda v: f"{v:,.0f}"),
]

out_dir = os.path.expanduser("~")
saved = []

for metric, ylabel, total_fmt in metrics:
    fig, axes = plt.subplots(3, 2, figsize=(16, 14), sharex=True)
    fig.suptitle(f"Daily {ylabel}", fontsize=18, fontweight="bold", y=0.97)

    src_vals = {}
    for name, (daily, color) in sources.items():
        vals = [daily.get(d, {}).get(metric, 0) for d in date_range]
        src_vals[name] = vals

    combined = [sum(src_vals[n][i] for n in sources) for i in range(len(date_range))]
    panels = [
        (axes[0, 0], "Claude Code", src_vals["Claude Code"], "#E07A5F"),
        (axes[0, 1], "OpenClaw", src_vals["OpenClaw"], "#3D85C6"),
        (axes[1, 0], "OpenCode", src_vals["OpenCode"], "#81B29A"),
        (axes[1, 1], "OpenWhispr", src_vals["OpenWhispr"], "#D4A843"),
    ]

    for ax, title, vals, color in panels:
        ax.bar(
            date_range, vals, color=color, alpha=0.85, edgecolor="white", linewidth=0.3
        )
        ax.set_title(title, fontsize=14, fontweight="bold", pad=10)
        ax.set_ylabel(ylabel, fontsize=11)
        ax.xaxis.set_major_formatter(mdates.DateFormatter("%b %d"))
        ax.xaxis.set_major_locator(
            mdates.DayLocator(interval=max(1, len(date_range) // 10))
        )
        ax.tick_params(axis="x", rotation=45, labelsize=9)
        ax.tick_params(axis="y", labelsize=9)
        ax.text(
            0.98,
            0.95,
            f"Total: {total_fmt(sum(vals))}",
            transform=ax.transAxes,
            ha="right",
            va="top",
            fontsize=11,
            fontweight="bold",
            bbox=dict(boxstyle="round,pad=0.3", facecolor="white", alpha=0.8),
        )

    # Combined stacked
    ax = axes[2, 0]
    cc_v, oc_v, oe_v, ow_v = (
        src_vals["Claude Code"],
        src_vals["OpenClaw"],
        src_vals["OpenCode"],
        src_vals["OpenWhispr"],
    )
    ax.bar(
        date_range,
        cc_v,
        color="#E07A5F",
        alpha=0.85,
        label="Claude Code",
        edgecolor="white",
        linewidth=0.3,
    )
    ax.bar(
        date_range,
        oc_v,
        bottom=cc_v,
        color="#3D85C6",
        alpha=0.85,
        label="OpenClaw",
        edgecolor="white",
        linewidth=0.3,
    )
    bot2 = [a + b for a, b in zip(cc_v, oc_v)]
    ax.bar(
        date_range,
        oe_v,
        bottom=bot2,
        color="#81B29A",
        alpha=0.85,
        label="OpenCode",
        edgecolor="white",
        linewidth=0.3,
    )
    bot3 = [a + b for a, b in zip(bot2, oe_v)]
    ax.bar(
        date_range,
        ow_v,
        bottom=bot3,
        color="#D4A843",
        alpha=0.85,
        label="OpenWhispr",
        edgecolor="white",
        linewidth=0.3,
    )
    ax.set_title("Combined", fontsize=14, fontweight="bold", pad=10)
    ax.set_ylabel(ylabel, fontsize=11)
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%b %d"))
    ax.xaxis.set_major_locator(
        mdates.DayLocator(interval=max(1, len(date_range) // 10))
    )
    ax.tick_params(axis="x", rotation=45, labelsize=9)
    ax.tick_params(axis="y", labelsize=9)
    ax.legend(loc="upper left", fontsize=9, framealpha=0.9)
    ax.text(
        0.98,
        0.95,
        f"Total: {total_fmt(sum(combined))}",
        transform=ax.transAxes,
        ha="right",
        va="top",
        fontsize=11,
        fontweight="bold",
        bbox=dict(boxstyle="round,pad=0.3", facecolor="white", alpha=0.8),
    )

    # Hide unused subplot
    axes[2, 1].set_visible(False)

    plt.tight_layout(rect=[0, 0, 1, 0.94])
    out_path = os.path.join(out_dir, f"token_{metric}.png")
    plt.savefig(out_path, dpi=150, bbox_inches="tight")
    plt.close()
    saved.append(out_path)

for p in saved:
    print(f"Saved: {p}")
    os.system(f"open '{p}'")
