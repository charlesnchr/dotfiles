#!/bin/bash
# Claude Code notification hook - sends notification with click-to-focus
# Spawns a detached subshell that runs terminal-notifier in foreground
# (nohup on terminal-notifier directly breaks its click handler)
# Reads JSON payload from stdin to show richer context

fallback_message="${1:-Needs attention}"

# Read hook payload from stdin (with timeout to avoid blocking)
read -t 0.1 -d '' payload 2>/dev/null || true

# Try to extract richer message from JSON payload
message=""
if [ -n "$payload" ]; then
    hook_event=$(echo "$payload" | jq -r '.hook_event_name // empty' 2>/dev/null)

    case "$hook_event" in
        Notification)
            # Use the actual notification message from Claude Code
            message=$(echo "$payload" | jq -r '.message // empty' 2>/dev/null)
            ;;
        PermissionRequest)
            tool_name=$(echo "$payload" | jq -r '.tool_name // empty' 2>/dev/null)
            tool_detail=$(echo "$payload" | jq -r '(.tool_input.command // .tool_input.file_path // empty)' 2>/dev/null)
            if [ -n "$tool_detail" ]; then
                message="$tool_name: ${tool_detail:0:80}"
            elif [ -n "$tool_name" ]; then
                message="Allow $tool_name?"
            fi
            ;;
        Stop)
            # Show recent git commit if one was just made, otherwise file change count
            recent=$(git log --oneline -1 --since='2 minutes ago' 2>/dev/null)
            if [ -n "$recent" ]; then
                message="Done — $recent"
            else
                modified=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
                if [ "$modified" -gt 0 ]; then
                    message="Done — $modified file(s) modified"
                fi
            fi
            ;;
    esac
fi
message="${message:-$fallback_message}"

if [ -n "$TMUX" ]; then
    tmux_socket=$(echo "$TMUX" | cut -d',' -f1)
    # Use -t "$TMUX_PANE" to query the pane where Claude Code is running,
    # not whichever window happens to be active when the hook fires
    tmux_target=$(tmux display-message -t "$TMUX_PANE" -p '#{session_name}:#{window_index}.#{pane_id}')
    window_name=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')
    session_name=$(tmux display-message -t "$TMUX_PANE" -p '#{session_name}')

    title="$window_name — $session_name"

    # Run terminal-notifier in a detached subshell (foreground within it)
    # so its click handler stays alive without blocking the caller
    (
        /opt/homebrew/bin/terminal-notifier \
            -title "$title" \
            -message "$message" \
            -sound default \
            -execute "$HOME/.claude/hooks/focus.sh '$tmux_socket' '$tmux_target'"
    ) </dev/null >/dev/null 2>&1 & disown
else
    (
        /opt/homebrew/bin/terminal-notifier \
            -title "Claude Code" \
            -message "$message" \
            -sound default \
            -activate com.mitchellh.ghostty
    ) </dev/null >/dev/null 2>&1 & disown
fi
