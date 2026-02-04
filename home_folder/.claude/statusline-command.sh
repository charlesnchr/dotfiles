#!/bin/bash

# Professional Powerline Status Line for Claude Code
# Implements proper powerline styling with seamless color transitions

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON input
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
transcript_path=$(echo "$input" | jq -r '.transcript_path')
model=$(echo "$input" | jq -r '.model.display_name')
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Powerline separator character (right-pointing triangle - Unicode E0B0)
SEP=$(printf '\xee\x82\xb0')

# Sophisticated Cool Gray/Blue Palette (ANSI 256-color codes)
# Line 1: User@host → Directory → Git → Model
COLOR_BG_1="\033[48;5;60m"     # deepSlate #5f5f87 → ANSI 60 (user@host - Line 1)
COLOR_FG_1="\033[38;5;60m"     # deepSlate foreground (for separators)
COLOR_TEXT_1="\033[38;5;231m"  # White text (ANSI 231) on deepSlate

COLOR_BG_2="\033[48;5;66m"     # graphite #5f8787 → ANSI 66 (directory - Line 1)
COLOR_FG_2="\033[38;5;66m"     # graphite foreground
COLOR_TEXT_2="\033[38;5;231m"  # White text (ANSI 231) on graphite

COLOR_BG_3="\033[48;5;67m"     # slate #5f87af → ANSI 67 (git - Line 1)
COLOR_FG_3="\033[38;5;67m"     # slate foreground
COLOR_TEXT_3="\033[38;5;231m"  # White text (ANSI 231) on slate

COLOR_BG_4="\033[48;5;68m"     # dustyBlue #5f87d7 → ANSI 68 (model - Line 1)
COLOR_FG_4="\033[38;5;68m"     # dustyBlue foreground
COLOR_TEXT_4="\033[38;5;231m"  # White text (ANSI 231) on dustyBlue

COLOR_BG_5="\033[48;5;103m"    # pewter #8787af → ANSI 103 (In tokens - Line 2)
COLOR_FG_5="\033[38;5;103m"    # pewter foreground
COLOR_TEXT_5="\033[38;5;16m"   # Black text (ANSI 16) on pewter

COLOR_BG_ORANGE="\033[48;5;109m" # teal #87afaf → ANSI 109 (Out tokens - Line 2)
COLOR_FG_ORANGE="\033[38;5;109m" # teal foreground
COLOR_TEXT_ORANGE="\033[38;5;16m" # Black text (ANSI 16) on teal

COLOR_BG_CYAN="\033[48;5;110m"   # periwinkle #87afd7 → ANSI 110 (Cache tokens - Line 2)
COLOR_FG_CYAN="\033[38;5;110m"   # periwinkle foreground
COLOR_TEXT_CYAN="\033[38;5;16m"  # Black text (ANSI 16) on periwinkle

COLOR_BG_DARK="\033[48;5;151m"   # sage #afd7af → ANSI 151 (Context - Line 2)
COLOR_FG_DARK="\033[38;5;151m"   # sage foreground
COLOR_TEXT_DARK="\033[38;5;16m"  # Black text (ANSI 16) on sage

RESET="\033[0m"

# Helper function to format token counts
format_tokens() {
    local count=$1
    if [ "$count" -ge 1000000 ]; then
        printf "%.1fM" $(echo "scale=1; $count / 1000000" | bc)
    elif [ "$count" -ge 1000 ]; then
        printf "%.1fk" $(echo "scale=1; $count / 1000" | bc)
    else
        echo "$count"
    fi
}

# Parse transcript for token metrics
parse_transcript() {
    local path="$1"
    local input_tokens=0
    local output_tokens=0
    local cached_tokens=0
    local context_length=0
    local first_timestamp=""
    local last_timestamp=""

    if [ -f "$path" ]; then
        # Parse JSONL file
        while IFS= read -r line; do
            # Extract usage data
            local usage=$(echo "$line" | jq -r '.message.usage // empty' 2>/dev/null)
            if [ -n "$usage" ] && [ "$usage" != "null" ]; then
                local in_tok=$(echo "$line" | jq -r '.message.usage.input_tokens // 0')
                local out_tok=$(echo "$line" | jq -r '.message.usage.output_tokens // 0')
                local cache_read=$(echo "$line" | jq -r '.message.usage.cache_read_input_tokens // 0')
                local cache_create=$(echo "$line" | jq -r '.message.usage.cache_creation_input_tokens // 0')

                input_tokens=$((input_tokens + in_tok))
                output_tokens=$((output_tokens + out_tok))
                cached_tokens=$((cached_tokens + cache_read + cache_create))

                # Track most recent context length (from last entry)
                local is_sidechain=$(echo "$line" | jq -r '.isSidechain // false')
                if [ "$is_sidechain" = "false" ]; then
                    context_length=$((in_tok + cache_read + cache_create))
                fi
            fi

            # Track timestamps for session duration
            local ts=$(echo "$line" | jq -r '.timestamp // empty' 2>/dev/null)
            if [ -n "$ts" ] && [ "$ts" != "null" ]; then
                if [ -z "$first_timestamp" ]; then
                    first_timestamp="$ts"
                fi
                last_timestamp="$ts"
            fi
        done < "$path"
    fi

    # Calculate session duration
    local duration=""
    if [ -n "$first_timestamp" ] && [ -n "$last_timestamp" ]; then
        local first_sec=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${first_timestamp:0:19}" "+%s" 2>/dev/null)
        local last_sec=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${last_timestamp:0:19}" "+%s" 2>/dev/null)
        if [ -n "$first_sec" ] && [ -n "$last_sec" ]; then
            local diff=$((last_sec - first_sec))
            local minutes=$((diff / 60))
            if [ "$minutes" -lt 1 ]; then
                duration="<1m"
            elif [ "$minutes" -lt 60 ]; then
                duration="${minutes}m"
            else
                local hours=$((minutes / 60))
                local mins=$((minutes % 60))
                duration="${hours}hr ${mins}m"
            fi
        fi
    fi

    # Calculate context percentage (out of 200K)
    local context_pct=0
    if [ "$context_length" -gt 0 ]; then
        context_pct=$(echo "scale=1; ($context_length * 100) / 200000" | bc)
    fi

    echo "$input_tokens|$output_tokens|$cached_tokens|$context_length|$context_pct|$duration"
}

# Get token metrics from transcript
metrics=$(parse_transcript "$transcript_path")
IFS='|' read -r input_tok output_tok cached_tok context_len context_pct session_dur <<< "$metrics"

# Format token counts
input_fmt=$(format_tokens "$input_tok")
output_fmt=$(format_tokens "$output_tok")
cached_fmt=$(format_tokens "$cached_tok")

# Function to get git insertion/deletion stats
get_git_changes() {
    local current_dir="$1"
    local insertions=0
    local deletions=0

    # Get unstaged changes
    local unstaged=$(cd "$current_dir" 2>/dev/null && git -c core.fsmonitor=false diff --shortstat 2>/dev/null)
    if [ -n "$unstaged" ]; then
        insertions=$(echo "$unstaged" | sed -n 's/.*\([0-9]\+\) insertion.*/\1/p')
        deletions=$(echo "$unstaged" | sed -n 's/.*\([0-9]\+\) deletion.*/\1/p')
        # Handle empty matches
        insertions=${insertions:-0}
        deletions=${deletions:-0}
    fi

    # Get staged changes
    local staged=$(cd "$current_dir" 2>/dev/null && git -c core.fsmonitor=false diff --cached --shortstat 2>/dev/null)
    if [ -n "$staged" ]; then
        local staged_ins=$(echo "$staged" | sed -n 's/.*\([0-9]\+\) insertion.*/\1/p')
        local staged_del=$(echo "$staged" | sed -n 's/.*\([0-9]\+\) deletion.*/\1/p')
        # Handle empty matches
        staged_ins=${staged_ins:-0}
        staged_del=${staged_del:-0}
        insertions=$((insertions + staged_ins))
        deletions=$((deletions + staged_del))
    fi

    if [ $insertions -gt 0 ] || [ $deletions -gt 0 ]; then
        echo "(+$insertions,-$deletions)"
    fi
}

# Git information (skip optional locks for performance)
git_worktree=""
if [ -d "$current_dir/.git" ] || [ -f "$current_dir/.git" ]; then
    git_branch=$(cd "$current_dir" 2>/dev/null && git -c core.fsmonitor=false branch --show-current 2>/dev/null)
    git_status=$(cd "$current_dir" 2>/dev/null && git -c core.fsmonitor=false status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    git_changes=$(get_git_changes "$current_dir")

    # Detect if we're in a git worktree
    git_dir=$(cd "$current_dir" 2>/dev/null && git -c core.fsmonitor=false rev-parse --git-dir 2>/dev/null)
    if [[ "$git_dir" == *"/.git/worktrees/"* ]]; then
        # Extract worktree name from path
        git_worktree=$(basename "$git_dir")
    fi
else
    git_branch=""
    git_status="0"
    git_changes=""
fi

# Build directory path (basename)
dir_name=$(basename "$current_dir")

# === LINE 1: User@host | Directory | Git | Model ===
# Cool gray/blue flow: deepSlate → graphite → slate → dustyBlue

line1=""

# Segment 1: User@host (deepSlate background, white text)
line1+="${COLOR_BG_1}${COLOR_TEXT_1} $(whoami)@$(hostname -s) ${RESET}"
# Arrow transition: deepSlate -> graphite
line1+="${COLOR_FG_1}${COLOR_BG_2}${SEP}${RESET}"

# Segment 2: Directory (graphite background, white text)
line1+="${COLOR_BG_2}${COLOR_TEXT_2} 📁 ${dir_name} ${RESET}"

# Git segment (only if in a git repo)
if [ -n "$git_branch" ]; then
    # Arrow: graphite -> slate
    line1+="${COLOR_FG_2}${COLOR_BG_3}${SEP}${RESET}"
    # Segment 3: Git branch (slate background, white text)
    line1+="${COLOR_BG_3}${COLOR_TEXT_3}"

    # Show worktree if applicable
    if [ -n "$git_worktree" ]; then
        line1+=" 𖠰 ${git_worktree}"
    fi

    # Show branch
    if [ "$git_status" -gt 0 ]; then
        line1+="  ${git_branch} ●${RESET}${COLOR_BG_3}${COLOR_TEXT_3}"
    else
        line1+="  ${git_branch}"
    fi

    # Show changes if any
    if [ -n "$git_changes" ]; then
        line1+=" ${git_changes}"
    fi

    line1+=" ${RESET}"
    # Arrow: slate -> dustyBlue
    line1+="${COLOR_FG_3}${COLOR_BG_4}${SEP}${RESET}"
else
    # No git: arrow from graphite -> dustyBlue
    line1+="${COLOR_FG_2}${COLOR_BG_4}${SEP}${RESET}"
fi

# Segment 4: Model (dustyBlue background, white text)
line1+="${COLOR_BG_4}${COLOR_TEXT_4} 🤖 ${model} ${RESET}"
# Final arrow: dustyBlue -> transparent
line1+="${COLOR_FG_4}${SEP}${RESET}"

# === LINE 2: Tokens | Context | Duration | Cost ===
# Cool gray/blue flow: pewter → teal → periwinkle → softBlue → fog → paleBlue
line2=""

# Segment 1: Input Tokens (pewter background, black text)
line2+="${COLOR_BG_5}${COLOR_TEXT_5} ⚡ In:${input_fmt} ${RESET}"
# Arrow: pewter -> teal
line2+="${COLOR_FG_5}${COLOR_BG_ORANGE}${SEP}${RESET}"

# Segment 2: Output Tokens (teal background, black text)
line2+="${COLOR_BG_ORANGE}${COLOR_TEXT_ORANGE} Out:${output_fmt} ${RESET}"
# Arrow: teal -> periwinkle
line2+="${COLOR_FG_ORANGE}${COLOR_BG_CYAN}${SEP}${RESET}"

# Segment 3: Cache Tokens (periwinkle background, black text)
line2+="${COLOR_BG_CYAN}${COLOR_TEXT_CYAN} Cache:${cached_fmt} ${RESET}"
# Arrow: periwinkle -> softBlue
line2+="${COLOR_FG_CYAN}${COLOR_BG_DARK}${SEP}${RESET}"

# Segment 4: Context (softBlue background, black text)
line2+="${COLOR_BG_DARK}${COLOR_TEXT_DARK} 📊 Ctx:${context_len} (${context_pct}%) ${RESET}"

# Define fog color for Duration (Line 2)
COLOR_BG_FOG="\033[48;5;145m"    # fog #afafaf → ANSI 145 (Duration - Line 2)
COLOR_FG_FOG="\033[38;5;145m"    # fog foreground
COLOR_TEXT_FOG="\033[38;5;16m"   # Black text (ANSI 16) on fog

# Duration segment (if available)
if [ -n "$session_dur" ]; then
    # Arrow: softBlue -> fog
    line2+="${COLOR_FG_DARK}${COLOR_BG_FOG}${SEP}${RESET}"
    # Segment 5: Duration (fog background, black text)
    line2+="${COLOR_BG_FOG}${COLOR_TEXT_FOG} ⏱ ${session_dur} ${RESET}"
    LAST_BG="${COLOR_BG_FOG}"
    LAST_FG="${COLOR_FG_FOG}"
else
    LAST_BG="${COLOR_BG_DARK}"
    LAST_FG="${COLOR_FG_DARK}"
fi

# Cost segment (if available)
if [ -n "$session_cost" ]; then
    # Define a distinct color for cost (paleBlue)
    COLOR_BG_COST="\033[48;5;146m"    # paleBlue #afafd7 → ANSI 146 (Cost - Line 2)
    COLOR_FG_COST="\033[38;5;146m"    # paleBlue foreground
    COLOR_TEXT_COST="\033[38;5;16m"   # Black text (ANSI 16) on paleBlue

    # Arrow from last segment to cost
    line2+="${LAST_FG}${COLOR_BG_COST}${SEP}${RESET}"
    # Segment 6: Cost (paleBlue background)
    # Format cost with 1 decimal place
    cost_formatted=$(printf "%.1f" "$session_cost")
    line2+="${COLOR_BG_COST}${COLOR_TEXT_COST} 💰 \$${cost_formatted} ${RESET}"
    # Final arrow for line 2: cost -> transparent
    line2+="${COLOR_FG_COST}${SEP}${RESET}"
else
    # No cost, end line 2 after last segment
    line2+="${LAST_FG}${SEP}${RESET}"
fi

# Output lines
printf "%b\n" "$line1"
printf "%b\n" "$line2"
