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

# -- Args ---------------------------------------------------------------------
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


# -- ANSI ---------------------------------------------------------------------
DIM = "\033[90m"
CYAN = "\033[36m"
RESET = "\033[39m"


# -- Helpers ------------------------------------------------------------------
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
            continue

        for i, model in enumerate(models):
            p = usage_by_period[period][model]
            provider = p.get("provider")
            model_label = fmt_model(model, provider)
            date_label = year if i == 0 else (month_day if i == 1 and month_day else "")
            entries.append(
                {
                    "type": "data",
                    "date": date_label,
                    "model": model_label,
                    "input": fmt_num(p["input"]),
                    "output": fmt_num(p["output"]),
                    "cache_wr": fmt_num(p["cacheWr"]),
                    "cache_rd": fmt_num(p["cacheRd"]),
                    "total": fmt_num(p["total"]),
                    "cost": fmt_cost(p["cost"]),
                }
            )

        entries.append({"type": "sep"})

    if entries and entries[-1]["type"] == "sep":
        entries.pop()

    labels = col_labels or {
        "date": "Date",
        "model": "Model",
        "input": "Input",
        "output": "Output",
        "cache_wr": "CacheWr",
        "cache_rd": "CacheRd",
        "total": "Total",
        "cost": "Cost",
    }

    widths = {k: len(v) for k, v in labels.items()}
    for e in entries:
        if e["type"] == "data":
            for k in widths:
                widths[k] = max(widths[k], len(e.get(k, "")))
        elif e["type"] == "date_cont":
            widths["date"] = max(widths["date"], len(e["date"]))

    rule = "-+-".join("-" * widths[k] for k in labels)
    header = " | ".join(labels[k].ljust(widths[k]) for k in labels)

    print(f"\n{title}")
    print(header)
    print(rule)

    for e in entries:
        if e["type"] == "data":
            print(
                " | ".join(
                    [
                        e["date"].ljust(widths["date"]),
                        e["model"].ljust(widths["model"]),
                        e["input"].rjust(widths["input"]),
                        e["output"].rjust(widths["output"]),
                        e["cache_wr"].rjust(widths["cache_wr"]),
                        e["cache_rd"].rjust(widths["cache_rd"]),
                        e["total"].rjust(widths["total"]),
                        e["cost"].rjust(widths["cost"]),
                    ]
                )
            )
        elif e["type"] == "date_cont":
            print(e["date"].ljust(widths["date"]))
        elif e["type"] == "sep":
            print(rule)

    if totals:
        print(rule)
        total_model = totals.get("model", "TOTAL")
        print(
            " | ".join(
                [
                    "".ljust(widths["date"]),
                    total_model.ljust(widths["model"]),
                    fmt_num(totals["input"]).rjust(widths["input"]),
                    fmt_num(totals["output"]).rjust(widths["output"]),
                    fmt_num(totals["cacheWr"]).rjust(widths["cache_wr"]),
                    fmt_num(totals["cacheRd"]).rjust(widths["cache_rd"]),
                    fmt_num(totals["total"]).rjust(widths["total"]),
                    fmt_cost(totals["cost"]).rjust(widths["cost"]),
                ]
            )
        )


def empty_totals(model="TOTAL"):
    return {
        "model": model,
        "input": 0,
        "output": 0,
        "cacheWr": 0,
        "cacheRd": 0,
        "total": 0,
        "cost": 0.0,
    }


def add_usage(
    bucket, model, provider, input_toks, output_toks, cache_wr, cache_rd, cost
):
    stats = bucket.setdefault(
        model,
        {
            "provider": provider,
            "input": 0,
            "output": 0,
            "cacheWr": 0,
            "cacheRd": 0,
            "total": 0,
            "cost": 0.0,
        },
    )
    stats["input"] += input_toks
    stats["output"] += output_toks
    stats["cacheWr"] += cache_wr
    stats["cacheRd"] += cache_rd
    stats["total"] += input_toks + output_toks + cache_wr + cache_rd
    stats["cost"] += cost


def merge_totals(total, stats):
    total["input"] += stats["input"]
    total["output"] += stats["output"]
    total["cacheWr"] += stats["cacheWr"]
    total["cacheRd"] += stats["cacheRd"]
    total["total"] += stats["total"]
    total["cost"] += stats["cost"]


def parse_iso(ts):
    if ts.endswith("Z"):
        ts = ts[:-1] + "+00:00"
    return datetime.fromisoformat(ts)


def get_json(obj, *path, default=None):
    cur = obj
    for key in path:
        if isinstance(cur, dict) and key in cur:
            cur = cur[key]
        else:
            return default
    return cur


def safe_int(value):
    try:
        return int(value or 0)
    except (TypeError, ValueError):
        return 0


def safe_float(value):
    try:
        return float(value or 0)
    except (TypeError, ValueError):
        return 0.0


def collect_openclaw_usage():
    usage = defaultdict(dict)
    totals = empty_totals()
    path = os.path.expanduser("~/.local/share/openclaw/usage/*.jsonl")

    for filename in sorted(glob.glob(path)):
        with open(filename, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    row = json.loads(line)
                except json.JSONDecodeError:
                    continue

                ts = row.get("timestamp")
                if not ts:
                    continue

                dt_obj = parse_iso(ts)
                period = to_period(dt_obj, group_mode)
                model = row.get("model", "unknown")
                provider = row.get("provider")
                input_toks = safe_int(row.get("input_tokens"))
                output_toks = safe_int(row.get("output_tokens"))
                cache_wr = safe_int(row.get("cache_creation_tokens"))
                cache_rd = safe_int(row.get("cache_read_tokens"))
                cost = safe_float(row.get("cost_usd"))

                add_usage(
                    usage[period],
                    model,
                    provider,
                    input_toks,
                    output_toks,
                    cache_wr,
                    cache_rd,
                    cost,
                )

    for models in usage.values():
        for stats in models.values():
            merge_totals(totals, stats)

    return usage, totals


def collect_opencode_usage():
    usage = defaultdict(dict)
    totals = empty_totals()
    db_path = os.path.expanduser("~/.config/opencode/opencode.db")

    if not os.path.exists(db_path):
        return usage, totals

    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()

    cur.execute(
        """
        SELECT started_at, provider, model, input_tokens, output_tokens,
               cache_write_tokens, cache_read_tokens, cost_usd
        FROM usage
        ORDER BY started_at
        """
    )

    for row in cur.fetchall():
        started_at = row["started_at"]
        if not started_at:
            continue
        dt_obj = parse_iso(started_at)
        period = to_period(dt_obj, group_mode)
        model = row["model"] or "unknown"
        provider = row["provider"]
        input_toks = safe_int(row["input_tokens"])
        output_toks = safe_int(row["output_tokens"])
        cache_wr = safe_int(row["cache_write_tokens"])
        cache_rd = safe_int(row["cache_read_tokens"])
        cost = safe_float(row["cost_usd"])

        add_usage(
            usage[period],
            model,
            provider,
            input_toks,
            output_toks,
            cache_wr,
            cache_rd,
            cost,
        )

    conn.close()

    for models in usage.values():
        for stats in models.values():
            merge_totals(totals, stats)

    return usage, totals


def collect_openwhispr_usage():
    usage = defaultdict(dict)
    totals = empty_totals()
    path = os.path.expanduser("~/personal/openwhispr/usage/*.jsonl")

    for filename in sorted(glob.glob(path)):
        with open(filename, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    row = json.loads(line)
                except json.JSONDecodeError:
                    continue

                ts = row.get("timestamp")
                if not ts:
                    continue

                dt_obj = parse_iso(ts)
                period = to_period(dt_obj, group_mode)
                model = row.get("model", "unknown")
                provider = row.get("provider")
                input_toks = safe_int(row.get("input_tokens"))
                output_toks = safe_int(row.get("output_tokens"))
                cache_wr = safe_int(row.get("cache_creation_tokens"))
                cache_rd = safe_int(row.get("cache_read_tokens"))
                cost = safe_float(row.get("cost_usd"))

                add_usage(
                    usage[period],
                    model,
                    provider,
                    input_toks,
                    output_toks,
                    cache_wr,
                    cache_rd,
                    cost,
                )

    for models in usage.values():
        for stats in models.values():
            merge_totals(totals, stats)

    return usage, totals


def collect_claude_usage():
    usage = defaultdict(dict)
    totals = empty_totals()
    path = os.path.expanduser("~/.claude/projects/**/*.jsonl")

    for filename in sorted(glob.glob(path, recursive=True)):
        with open(filename, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    row = json.loads(line)
                except json.JSONDecodeError:
                    continue

                if row.get("type") != "usage":
                    continue

                ts = row.get("timestamp")
                if not ts:
                    continue

                dt_obj = parse_iso(ts)
                period = to_period(dt_obj, group_mode)
                message = row.get("message", {})
                model = get_json(message, "model") or row.get("model") or "unknown"
                provider = row.get("provider") or "anthropic"
                usage_info = get_json(message, "usage", default={})
                input_toks = safe_int(usage_info.get("input_tokens"))
                output_toks = safe_int(usage_info.get("output_tokens"))
                cache_wr = safe_int(usage_info.get("cache_creation_input_tokens"))
                cache_rd = safe_int(usage_info.get("cache_read_input_tokens"))
                cost = safe_float(row.get("cost_usd"))

                add_usage(
                    usage[period],
                    model,
                    provider,
                    input_toks,
                    output_toks,
                    cache_wr,
                    cache_rd,
                    cost,
                )

    for models in usage.values():
        for stats in models.values():
            merge_totals(totals, stats)

    return usage, totals


def combine_tables(tables):
    usage = defaultdict(dict)
    totals = empty_totals()

    for source_name, source_usage, source_totals in tables:
        if not should_show(source_name):
            continue

        for period, models in source_usage.items():
            for model, stats in models.items():
                scoped_model = f"{source_name}:{model}"
                usage[period][scoped_model] = dict(stats)

        merge_totals(totals, source_totals)

    return usage, totals


def main():
    sources = []

    oc_usage, oc_totals = collect_openclaw_usage()
    sources.append(("openclaw", oc_usage, oc_totals))

    oe_usage, oe_totals = collect_opencode_usage()
    sources.append(("opencode", oe_usage, oe_totals))

    ow_usage, ow_totals = collect_openwhispr_usage()
    sources.append(("openwhispr", ow_usage, ow_totals))

    claude_usage, claude_totals = collect_claude_usage()
    sources.append(("claude", claude_usage, claude_totals))

    if show_breakdown:
        for source_name, source_usage, source_totals in sources:
            if should_show(source_name):
                print_table(source_name, source_usage, source_totals, group_mode, True)
    else:
        combined_usage, combined_totals = combine_tables(sources)
        print_table("usage", combined_usage, combined_totals, group_mode, False)

    if show_plot:
        print(f"{DIM}Plot output not implemented in this copy.{RESET}")


if __name__ == "__main__":
    main()
