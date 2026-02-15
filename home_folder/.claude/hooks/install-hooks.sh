#!/bin/bash
#
# Install Claude Code hooks into ~/.claude/settings.json
# Merges hook definitions while preserving all other settings.
# Safe to run multiple times (idempotent).
#

set -e

SETTINGS_FILE="$HOME/.claude/settings.json"

# Ensure the directory and file exist
mkdir -p "$(dirname "$SETTINGS_FILE")"
[ -f "$SETTINGS_FILE" ] || echo '{}' > "$SETTINGS_FILE"

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install with: brew install jq" >&2
    exit 1
fi

# Hook definitions to merge
hooks=$(cat <<'HOOKS_JSON'
{
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "[ -n \"$TMUX_PANE\" ] && tmux set-option -w -t \"$TMUX_PANE\" @claude_status 🤖"
        }
      ]
    }
  ],
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "[ -n \"$TMUX_PANE\" ] && tmux set-option -w -t \"$TMUX_PANE\" @claude_status ⚡"
        }
      ]
    }
  ],
  "Notification": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "[ -n \"$TMUX_PANE\" ] && tmux set-option -w -t \"$TMUX_PANE\" @claude_status 💬"
        },
        {
          "type": "command",
          "command": "$HOME/.claude/hooks/notify.sh 'Needs attention'"
        }
      ]
    }
  ],
  "PermissionRequest": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "[ -n \"$TMUX_PANE\" ] && tmux set-option -w -t \"$TMUX_PANE\" @claude_status 💬"
        },
        {
          "type": "command",
          "command": "$HOME/.claude/hooks/notify.sh 'Permission needed'"
        }
      ]
    }
  ],
  "Stop": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "[ -n \"$TMUX_PANE\" ] && tmux set-option -w -t \"$TMUX_PANE\" @claude_status 🤖"
        },
        {
          "type": "command",
          "command": "$HOME/.claude/hooks/notify.sh 'Task complete'"
        }
      ]
    }
  ],
  "SessionEnd": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "[ -n \"$TMUX_PANE\" ] && tmux set-option -wu -t \"$TMUX_PANE\" @claude_status"
        }
      ]
    }
  ]
}
HOOKS_JSON
)

# Merge hooks into settings, overwriting the hooks key
tmp=$(mktemp)
jq --argjson hooks "$hooks" '.hooks = $hooks' "$SETTINGS_FILE" > "$tmp" \
    && mv "$tmp" "$SETTINGS_FILE"

echo "Claude Code hooks installed into $SETTINGS_FILE"
