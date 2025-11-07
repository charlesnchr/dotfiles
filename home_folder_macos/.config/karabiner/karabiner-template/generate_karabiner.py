#!/usr/bin/env python3
"""Generate ~/.config/karabiner/karabiner.json from a single rules.json plus
per‑profile device tweaks.

Layout ::
  karabiner_template/
  ├─ generate_karabiner.py   (this file)
  ├─ rules.json              ← One file: {"title": ..., "rules": [ {...}, ... ]}
  └─ devices.json            ← File with the usual Karabiner device blocks

Edit the PROFILES list below to say which rule *descriptions* each profile
should import. Then run the script.
"""
import json
import sys
from pathlib import Path
from typing import Dict, List

ROOT = Path(__file__).resolve().parent
RULES_FILE = ROOT / "rules.json"
DEVICES_FILE = ROOT / "devices.json"
OUT_PATH = Path.home() / ".config/karabiner/karabiner.json"

GLOBAL = {
    "check_for_updates_on_startup": False,
    "show_in_menu_bar": False,
}

PARAMETERS = {
    "basic.simultaneous_threshold_milliseconds": 150,
    "basic.to_if_alone_timeout_milliseconds": 300,
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def load_all_rules() -> Dict[str, dict]:
    try:
        data = json.loads(RULES_FILE.read_text())
    except FileNotFoundError:
        sys.exit(f"rules file not found: {RULES_FILE}")
    if "rules" not in data or not isinstance(data["rules"], list):
        sys.exit("rules.json must look like a Karabiner complex_modifications export")
    # Index by description – descriptions must be unique!
    all_rules: Dict[str, dict] = {}
    for r in data["rules"]:
        desc = r.get("description")
        if not desc:
            sys.exit("every rule in rules.json needs a 'description'")
        if desc in all_rules:
            sys.exit(f"duplicate rule description: {desc}")
        all_rules[desc] = r
    return all_rules


ALL_RULES = load_all_rules()


def devices() -> List[dict]:
    f = DEVICES_FILE
    if not f.exists():
        return []
    return json.loads(f.read_text())

# ---------------------------------------------------------------------------
# Profiles – adjust as needed
# ---------------------------------------------------------------------------
# currently deactivated:
# "Yabai meta", "Option keys for symbols", "Option keys for home row",

PROFILES = [
    {
        "name": "Default profile",
        "selected": True,
        "rules": [
            "Vi Mode [S as Trigger Key]",
            "CapsLock to Hyper/Escape",
            "Hyper Navigation",
            "Fixing ae oe aa",
            "Option keys for symbols",
            "Extra right control for macbook keyboard",
            "Extra hyper key for macbook keyboard",
            "Corne capslock",
            "Map fn + number keys to function keys",
            "real f keys to designated features",
        ],
        "virtual_hid_keyboard": {"country_code": 0, "keyboard_type_v2": "ansi"},
    },
    {
        "name": "Gaming",
        "rules": [
            "CapsLock to Hyper/Escape",
            "Hyper Navigation",
            "Fixing ae oe aa",
            "Option keys for symbols",
            "function keys with designated features",
            "Fn to left control for gaming",
        ],
        "virtual_hid_keyboard": {"country_code": 0, "keyboard_type_v2": "ansi"},
    },
    {
        "name": "Simple",
        "rules": [
            "CapsLock to Hyper/Escape",
            "Hyper Navigation",
            "Fixing ae oe aa",
            "Map fn + number keys to their corresponding media control keys",
            "function keys with designated features",
        ],
        "virtual_hid_keyboard": {"country_code": 0, "keyboard_type_v2": "ansi"},
    },
]

# ---------------------------------------------------------------------------
# Builder
# ---------------------------------------------------------------------------

def build():
    cfg = {"global": GLOBAL, "profiles": []}

    for p in PROFILES:
        # translate description strings to full rule dicts
        profile_rules: List[dict] = []
        for desc in p["rules"]:
            rule = ALL_RULES.get(desc)
            if not rule:
                sys.exit(f"rule not found in {RULES_FILE}: '{desc}'")
            profile_rules.append(rule)

        cfg["profiles"].append(
            {
                "name": p["name"],
                "selected": p.get("selected", False),
                "simple_modifications": [],
                "complex_modifications": {
                    "parameters": PARAMETERS,
                    "rules": profile_rules,
                },
                "devices": devices(),
                "virtual_hid_keyboard": p.get("virtual_hid_keyboard", {}),
            }
        )

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text(json.dumps(cfg, indent=2))
    print("Wrote", OUT_PATH)


if __name__ == "__main__":
    build()

