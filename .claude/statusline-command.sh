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

# Muted Color Palette (ANSI 256-color codes)
# Professional, muted aesthetic with gentle colors
# Line 1: Warm earthy flow - mustard → taupe → olive → smoky taupe
COLOR_BG_1="\033[48;5;179m"    # Muted Mustard #D8B06C (user@host)
COLOR_FG_1="\033[38;5;179m"    # Muted Mustard foreground (for separators)
COLOR_TEXT_1="\033[38;5;16m"   # Black text on mustard

COLOR_BG_2="\033[48;5;66m"     # Gentle Teal #6B8E8C (In tokens - Line 2)
COLOR_FG_2="\033[38;5;66m"     # Gentle Teal foreground
COLOR_TEXT_2="\033[38;5;16m"   # Black text on teal

COLOR_BG_3="\033[48;5;181m"    # Smoky Taupe #BFA6A0 (model)
COLOR_FG_3="\033[38;5;181m"    # Smoky Taupe foreground
COLOR_TEXT_3="\033[38;5;16m"   # Black text on taupe

COLOR_BG_4="\033[48;5;101m"    # Muted Olive #8F9779 (git)
COLOR_FG_4="\033[38;5;101m"    # Muted Olive foreground
COLOR_TEXT_4="\033[38;5;16m"   # Black text on olive

COLOR_BG_5="\033[48;5;60m"     # Muted Navy #3A4F64 (Duration)
COLOR_FG_5="\033[38;5;60m"     # Muted Navy foreground
COLOR_TEXT_5="\033[38;5;231m"  # White text on navy

COLOR_BG_ORANGE="\033[48;5;138m" # Dusky Rose #C08081 (Out tokens)
COLOR_FG_ORANGE="\033[38;5;138m" # Dusky Rose foreground
COLOR_TEXT_ORANGE="\033[38;5;16m" # Black text on rose

COLOR_BG_CYAN="\033[48;5;109m"   # Dusty Blue #7A9E9F (Cache tokens)
COLOR_FG_CYAN="\033[38;5;109m"   # Dusty Blue foreground
COLOR_TEXT_CYAN="\033[38;5;16m"  # Black text on blue

COLOR_BG_DARK="\033[48;5;144m"   # Warm Taupe #B2A192 (directory - Line 1)
COLOR_FG_DARK="\033[38;5;144m"   # Warm Taupe foreground
COLOR_TEXT_DARK="\033[38;5;16m"  # Black text on taupe

RESET="\033[0m"
BOLD="\033[1m"

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

# Function to calculate block progress from claude-usage reset time
calculate_block_progress() {
    local reset_time="$1"  # e.g., "3pm" or "3:15pm"

    if [ -z "$reset_time" ]; then
        echo "0|[░░░░░░░░░░░░░░░░]"
        return
    fi

    # Parse reset time to get hour (convert 12-hour to 24-hour)
    local reset_hour=$(echo "$reset_time" | sed -E 's/([0-9]+)(:[0-9]+)?(am|pm)/\1/')
    local reset_minute=$(echo "$reset_time" | sed -E 's/[0-9]+:([0-9]+)(am|pm)/\1/')
    local reset_ampm=$(echo "$reset_time" | sed -E 's/.*([ap]m)/\1/')

    # Default minute to 0 if not specified
    if [ -z "$reset_minute" ] || [ "$reset_minute" = "$reset_time" ]; then
        reset_minute=0
    fi

    # Convert to 24-hour
    if [[ "$reset_ampm" == "pm" ]] && [ "$reset_hour" -ne 12 ]; then
        reset_hour=$((reset_hour + 12))
    elif [[ "$reset_ampm" == "am" ]] && [ "$reset_hour" -eq 12 ]; then
        reset_hour=0
    fi

    # Get current hour and minute
    local current_hour=$(date +%H)
    local current_minute=$(date +%M)

    # Calculate block start (5 hours before reset)
    local block_start_hour=$((reset_hour - 5))
    local block_start_minute=$reset_minute
    if [ $block_start_hour -lt 0 ]; then
        block_start_hour=$((block_start_hour + 24))
    fi

    # Calculate elapsed time in minutes
    local current_total_minutes=$((current_hour * 60 + current_minute))
    local block_start_total_minutes=$((block_start_hour * 60 + block_start_minute))
    local elapsed_minutes=$((current_total_minutes - block_start_total_minutes))

    # Handle day wraparound
    if [ $elapsed_minutes -lt 0 ]; then
        elapsed_minutes=$((elapsed_minutes + 1440))  # 24 hours in minutes
    fi

    # Calculate progress (0-100) - 5 hours = 300 minutes
    local progress_pct=$(( (elapsed_minutes * 100) / 300 ))
    if [ $progress_pct -gt 100 ]; then
        progress_pct=100
    fi
    if [ $progress_pct -lt 0 ]; then
        progress_pct=0
    fi

    # Create progress bar (16 chars)
    local filled=$(( (progress_pct * 16) / 100 ))
    local empty=$((16 - filled))

    local bar="["
    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    for ((i=0; i<empty; i++)); do
        bar+="░"
    done
    bar+="]"

    echo "$progress_pct|$bar"
}

# Get token metrics from transcript
metrics=$(parse_transcript "$transcript_path")
IFS='|' read -r input_tok output_tok cached_tok context_len context_pct session_dur <<< "$metrics"

# Format token counts
input_fmt=$(format_tokens "$input_tok")
output_fmt=$(format_tokens "$output_tok")
cached_fmt=$(format_tokens "$cached_tok")

# Block progress will be calculated after we get claude-usage data
block_pct=""
progress_bar=""

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

# Get claude-usage metrics with reset times
usage_session_pct=""
usage_session_reset=""
usage_week_pct=""
usage_week_reset=""
usage_error=""

# Helper function to shorten reset time format
shorten_reset_time() {
    local reset_time="$1"
    # Convert "2:59pm (Europe/London)" -> "2:59pm"
    # Convert "Nov 6 at 2:59pm (Europe/London)" -> "Nov 6 2:59pm"
    if [ -n "$reset_time" ]; then
        reset_time=$(echo "$reset_time" | sed 's/ (.*)//')  # Remove timezone
        reset_time=$(echo "$reset_time" | sed 's/ at / /')   # Remove "at"
    fi
    echo "$reset_time"
}

if command -v claude-usage &> /dev/null; then
    # Run with timeout to avoid hanging (10 second max)
    # Suppress stderr to avoid informational messages mixing with JSON
    usage_output=$(timeout 10 claude-usage 2>/dev/null)
    usage_exit_code=$?

    # Check if command failed or timed out
    if [ $usage_exit_code -eq 124 ]; then
        usage_error="timeout"
    elif [ $usage_exit_code -ne 0 ] || [ -z "$usage_output" ]; then
        usage_error="cmd_failed"
    else
        # With stderr suppressed, the output is now clean JSON
        json_output="$usage_output"

        if [ -n "$json_output" ]; then
            # Parse the JSON with the actual field names
            usage_session_pct=$(echo "$json_output" | jq -r '.current_session.percentage // empty' 2>/dev/null)
            usage_session_reset=$(echo "$json_output" | jq -r '.current_session.resets // empty' 2>/dev/null)
            usage_week_pct=$(echo "$json_output" | jq -r '.current_week_all_models.percentage // empty' 2>/dev/null)
            usage_week_reset=$(echo "$json_output" | jq -r '.current_week_all_models.resets // empty' 2>/dev/null)

            # Shorten reset times for display
            if [ -n "$usage_session_reset" ] && [ "$usage_session_reset" != "null" ]; then
                usage_session_reset=$(shorten_reset_time "$usage_session_reset")
            else
                usage_session_reset=""
            fi

            if [ -n "$usage_week_reset" ] && [ "$usage_week_reset" != "null" ]; then
                usage_week_reset=$(shorten_reset_time "$usage_week_reset")
            else
                usage_week_reset=""
            fi

            # Calculate block progress from session reset time (only if available)
            if [ -n "$usage_session_reset" ]; then
                block_progress=$(calculate_block_progress "$usage_session_reset")
                block_pct=$(echo "$block_progress" | cut -d'|' -f1)
                progress_bar=$(echo "$block_progress" | cut -d'|' -f2)
            fi
        fi

        # If still no data, mark as parse error
        if [ -z "$usage_session_pct" ]; then
            usage_error="parse_failed"
        fi
    fi
else
    usage_error="not_found"
fi

# Build directory path (basename)
dir_name=$(basename "$current_dir")

# === LINE 1: User@host | Directory | Git | Model ===
# Warm earthy color flow: mustard → taupe → olive → smoky taupe

line1=""

# Segment 1: User@host (Muted Mustard background, black text)
line1+="${COLOR_BG_1}${COLOR_TEXT_1}${BOLD} $(whoami)@$(hostname -s) ${RESET}"
# Arrow transition: mustard -> taupe
line1+="${COLOR_FG_1}${COLOR_BG_DARK}${SEP}${RESET}"

# Segment 2: Directory (Warm Taupe background, black text)
line1+="${COLOR_BG_DARK}${COLOR_TEXT_DARK} 📁 ${dir_name} ${RESET}"

# Git segment (only if in a git repo)
if [ -n "$git_branch" ]; then
    # Arrow: taupe -> olive
    line1+="${COLOR_FG_DARK}${COLOR_BG_4}${SEP}${RESET}"
    # Segment 3: Git branch (Faded Olive background, black text)
    line1+="${COLOR_BG_4}${COLOR_TEXT_4}"

    # Show worktree if applicable
    if [ -n "$git_worktree" ]; then
        line1+=" 𖠰 ${git_worktree}"
    fi

    # Show branch
    if [ "$git_status" -gt 0 ]; then
        line1+="${BOLD}  ${git_branch} ●${RESET}${COLOR_BG_4}${COLOR_TEXT_4}"
    else
        line1+="  ${git_branch}"
    fi

    # Show changes if any
    if [ -n "$git_changes" ]; then
        line1+=" ${git_changes}"
    fi

    line1+=" ${RESET}"
    # Arrow: olive -> blush
    line1+="${COLOR_FG_4}${COLOR_BG_3}${SEP}${RESET}"
else
    # No git: arrow from taupe -> blush
    line1+="${COLOR_FG_DARK}${COLOR_BG_3}${SEP}${RESET}"
fi

# Segment 4: Model (Soft Blush background, black text)
line1+="${COLOR_BG_3}${COLOR_TEXT_3} 🤖 ${model} ${RESET}"
# Final arrow: blush -> transparent
line1+="${COLOR_FG_3}${SEP}${RESET}"

# === LINE 2: Tokens | Context | Duration | Cost ===
line2=""

# Segment 1: Input Tokens (Yellow background)
line2+="${COLOR_BG_2}${COLOR_TEXT_2}${BOLD} ⚡ In:${input_fmt} ${RESET}"
# Arrow: yellow -> orange
line2+="${COLOR_FG_2}${COLOR_BG_ORANGE}${SEP}${RESET}"

# Segment 2: Output Tokens (Orange background)
line2+="${COLOR_BG_ORANGE}${COLOR_TEXT_ORANGE}${BOLD} Out:${output_fmt} ${RESET}"
# Arrow: orange -> cyan
line2+="${COLOR_FG_ORANGE}${COLOR_BG_CYAN}${SEP}${RESET}"

# Segment 3: Cache Tokens (Cyan background)
line2+="${COLOR_BG_CYAN}${COLOR_TEXT_CYAN}${BOLD} Cache:${cached_fmt} ${RESET}"
# Arrow: cyan -> dark gray
line2+="${COLOR_FG_CYAN}${COLOR_BG_DARK}${SEP}${RESET}"

# Segment 4: Context (Dark gray background)
line2+="${COLOR_BG_DARK}${COLOR_TEXT_DARK} 📊 Ctx:${context_len} (${context_pct}%) ${RESET}"

# Duration segment (if available)
if [ -n "$session_dur" ]; then
    # Arrow: dark gray -> purple
    line2+="${COLOR_FG_DARK}${COLOR_BG_5}${SEP}${RESET}"
    # Segment 5: Duration (Purple background)
    line2+="${COLOR_BG_5}${COLOR_TEXT_5} ⏱ ${session_dur} ${RESET}"
    LAST_BG="${COLOR_BG_5}"
    LAST_FG="${COLOR_FG_5}"
else
    LAST_BG="${COLOR_BG_DARK}"
    LAST_FG="${COLOR_FG_DARK}"
fi

# Cost segment (if available)
if [ -n "$session_cost" ]; then
    # Define a distinct color for cost (using muted lavender)
    COLOR_BG_COST="\033[48;5;145m"    # Muted Lavender #A3989D (Cost)
    COLOR_FG_COST="\033[38;5;145m"    # Muted Lavender foreground
    COLOR_TEXT_COST="\033[38;5;16m"   # Black text on lavender

    # Arrow from last segment to cost
    line2+="${LAST_FG}${COLOR_BG_COST}${SEP}${RESET}"
    # Segment 6: Cost (Muted Lavender background)
    # Format cost with 1 decimal place
    cost_formatted=$(printf "%.1f" "$session_cost")
    line2+="${COLOR_BG_COST}${COLOR_TEXT_COST}${BOLD} 💰 \$${cost_formatted} ${RESET}"
    # Final arrow for line 2: cost -> transparent
    line2+="${COLOR_FG_COST}${SEP}${RESET}"
else
    # No cost, end line 2 after last segment
    line2+="${LAST_FG}${SEP}${RESET}"
fi

# === LINE 3: Session Usage | Week Usage ===
line3=""

# Claude Usage segments (if available)
if [ -n "$usage_session_pct" ]; then
    # Define session color (Soft Sage)
    COLOR_BG_SESSION="\033[48;5;108m"   # Soft Sage #A3B18A (Session)
    COLOR_FG_SESSION="\033[38;5;108m"   # Soft Sage foreground
    COLOR_TEXT_SESSION="\033[38;5;16m"  # Black text on sage

    # Segment 1: Session usage (Soft Sage background)
    line3+="${COLOR_BG_SESSION}${COLOR_TEXT_SESSION}${BOLD} 📈 Session:${usage_session_pct}%"

    # Always add block timer progress bar (even if 0%)
    if [ -n "$progress_bar" ]; then
        line3+=" ${progress_bar} ${block_pct}%"
    fi

    if [ -n "$usage_session_reset" ]; then
        line3+=" (⏰${usage_session_reset})"
    fi
    line3+=" ${RESET}"

    # Week usage (if available)
    if [ -n "$usage_week_pct" ]; then
        # Define week color (Muted Coral)
        COLOR_BG_WEEK="\033[48;5;181m"    # Muted Coral #D8A39D (Week)
        COLOR_FG_WEEK="\033[38;5;181m"    # Muted Coral foreground
        COLOR_TEXT_WEEK="\033[38;5;16m"   # Black text on coral

        # Arrow: soft sage -> muted coral
        line3+="${COLOR_FG_SESSION}${COLOR_BG_WEEK}${SEP}${RESET}"
        # Segment 2: Week usage (Muted Coral background)
        line3+="${COLOR_BG_WEEK}${COLOR_TEXT_WEEK}${BOLD} 📅 Week:${usage_week_pct}%"
        if [ -n "$usage_week_reset" ]; then
            line3+=" (⏰${usage_week_reset})"
        fi
        line3+=" ${RESET}"
        # Final arrow: muted coral -> transparent
        line3+="${COLOR_FG_WEEK}${SEP}${RESET}"
    else
        # Final arrow: soft sage -> transparent
        line3+="${COLOR_FG_SESSION}${SEP}${RESET}"
    fi
elif [ -n "$usage_error" ]; then
    # Debug output if claude-usage failed
    line3+="${COLOR_BG_1}${COLOR_TEXT_1} ⚠️ claude-usage: ${usage_error} ${RESET}"
    line3+="${COLOR_FG_1}${SEP}${RESET}"
fi

# Output all three lines
printf "%b\n" "$line1"
printf "%b\n" "$line2"
if [ -n "$line3" ]; then
    printf "%b\n" "$line3"
fi
