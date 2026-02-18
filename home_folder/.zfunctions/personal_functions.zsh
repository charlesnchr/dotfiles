#!/bin/zsh

# Update tmux window git branch on each prompt
_update_tmux_git() {
  if [ -n "$TMUX_PANE" ]; then
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
      tmux set-option -wq -t "$TMUX_PANE" @git_branch "$branch"
    else
      tmux set-option -wqu -t "$TMUX_PANE" @git_branch 2>/dev/null
    fi
  fi
}
add-zsh-hook precmd _update_tmux_git

ssh() {
    if [ -n "$TMUX_PANE" ]; then
        local host="${@: -1}"
        host="${host##*@}"
        tmux set-option -wq -t "$TMUX_PANE" @ssh_host "$host"
        command ssh "$@"
        tmux set-option -wqu -t "$TMUX_PANE" @ssh_host 2>/dev/null
    else
        command ssh "$@"
    fi
}

jcd() {
	cd "$(j -s | fzf | awk '{$1=""; print $0}' |  sed -e 's/^[ \t]*//')"; zsh
}

function markdown-show() {
    # Accepts stdin, formats as JSON using fabric, then opens in nvim with Markdown preview
    fabric -p explain_charles -v '#format:json' --stream | nvim -c "set ft=markdown | MarkdownPreview" -
}

jf() {
    cd $(j -s | fzf | cut -d ":" -f 2 | xargs)
}

jr() {
    goto=$(j -s | fzf | cut -d ":" -f 2 | xargs); if [ $goto ] && r $goto
}


jv() {
	file="$(AUTOJUMP_DATA_DIR=~/.autojump.vim/global autojump $@)"; if [ -n "$file" ]; then vim "$file"; fi
}

jf() {
    cd $(j -s | fzf | cut -d ":" -f 2 | xargs)
}

e() {
    [[ ! $(tmux a) ]] && tmuxinator Home
}

tgz() {
    tar cf - "$@" | pv -s $[$(du -sk "$@" | awk '{print $1}') * 1024] | gzip > "$@".tgz
}

zstp() {
    tar -cf - "$@" | pv -s $[$(du -sk "$@" | awk '{print $1}') * 1024] | zstd -T0 > "$@".tar.zst
}

wikistats() {
    echo "Now at day:"
    date +%j

    echo "Total pages:"
    ls -1 ~/0main/Syncthing/wiki/diary/2023-*.wiki | wc -l | awk -F' ' '{print $1}'

    echo "Total words:"
    wc -w ~/0main/Syncthing/wiki/diary/2023-*.wiki | tail -n 1 | awk '{print $1}'

    echo "Number of days run:"
    grep "\[X\] Jogging" ~/0main/Syncthing/wiki/diary/** | wc -l | awk -F' ' '{print $1}'

    echo "Total distance:"
    grep "Jogging" ~/0main/Syncthing/wiki/diary/* --no-filename | sed 's/[^0-9]*//g' | awk '{s+=$1} END {print s}'

    echo "Number of days I've read:"
    grep "\[X\] Read," ~/0main/Syncthing/wiki/diary/** | wc -l | awk -F' ' '{print $1}'

    echo "Number of days making ankicards:"
    grep "\[X\] Anki flashcard" ~/0main/Syncthing/wiki/diary/** | wc -l | awk -F' ' '{print $1}'
}


# jog() {
#     sqlite3 $HOME/.histdb/zsh-history.db "
#     SELECT
#         replace(commands.argv, '
#         ', '
#         ')
#         FROM commands
#         JOIN history ON history.command_id = commands.id
#         JOIN places ON history.place_id = places.id
#         WHERE history.exit_status = 0
#         AND dir = '${PWD}'
#         AND places.host = '${HOST}'
#         AND commands.argv != 'jog'
#         AND commands.argv NOT LIKE 'z %'
#         AND commands.argv NOT LIKE 'cd %'
#         AND commands.argv != '..'
#         ORDER BY start_time DESC
#         LIMIT 10
#         "
#     }
# Disabled - histdb disabled for performance

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

function penv() {
    unalias python 2>/dev/null || true

    if [ -n "$1" ]; then
        # Conda activation
        source ~/anaconda3/etc/profile.d/conda.sh
        conda activate "$1"

        if ! pip show python-lsp-server &> /dev/null; then
            pip install 'python-lsp-server[all]'
        fi

        if ! pip show pynvim &> /dev/null; then
            pip install pynvim
        fi

        export PYTHON_LSP_HOME=$(dirname $(which python))
    else
        # Check if .venv exists before trying to activate
        if [ -f ".venv/bin/activate" ]; then
            source .venv/bin/activate

            if ! uv pip show python-lsp-server &> /dev/null; then
                uv pip install 'python-lsp-server[all]'
            fi

            if ! uv pip show pynvim &> /dev/null; then
                uv pip install pynvim
            fi

            export PYTHON_LSP_HOME=$(dirname $(which python))
        else
            echo "No .venv directory found in current directory. Skipping Python environment setup."
            return 0
        fi
    fi
}

function init_cargo() {
    export PATH="$HOME/.cargo/bin:$PATH"
    . "$HOME/.cargo/env"
}

alias c='ccv -y'
alias cr='ccv -yr'

function ccv() {
  local env_vars=(
    "ENABLE_BACKGROUND_TASKS=true"
    "FORCE_AUTO_BACKGROUND_TASKS=true"
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=true"
    "CLAUDE_CODE_ENABLE_UNIFIED_READ_TOOL=true"
  )

  local claude_args=()

  if [[ "$1" == "-y" ]]; then
    claude_args+=("--dangerously-skip-permissions")
  elif [[ "$1" == "-r" ]]; then
    claude_args+=("--resume")
  elif [[ "$1" == "-ry" || "$1" == "-yr" ]]; then
    claude_args+=("--resume" "--dangerously-skip-permissions")
  fi

  env "${env_vars[@]}" claude "${claude_args[@]}"
}

function ts() {
    local selected

    if [[ $# -eq 0 ]]; then
        selected=$(pwd)
    else
        selected=$1
    fi

    # Expand path properly
    selected=${selected/#\~/$HOME}
    selected=$(realpath "$selected" 2>/dev/null) || selected=$(cd "$selected" 2>/dev/null && pwd)

    if [[ ! -d $selected ]]; then
        echo "Directory does not exist: $selected"
        return 1
    fi

    local selected_name=$(basename "$selected" | tr . _)
    local tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        if [[ -d $selected ]]; then
            tmux new-session -s $selected_name -c "$selected"
        fi
        return 0
    fi

    if ! tmux has-session -t=$selected_name 2>/dev/null; then
        if [[ -d $selected ]]; then
            tmux new-session -ds $selected_name -c "$selected"
            tmux switch-client -t $selected_name
        fi
    else
        tmux switch-client -t $selected_name
    fi
}

kimi() {
    (
        export ANTHROPIC_BASE_URL=https://api.moonshot.ai/anthropic
        export ANTHROPIC_AUTH_TOKEN=$KIMI_API_KEY
        claude "$@"
    )
}

zai() {
    (
        export ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
        export ANTHROPIC_AUTH_TOKEN=$Z_API_KEY
        claude "$@"
    )
}

dseek() {
    (
        export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
        export ANTHROPIC_AUTH_TOKEN=${DEEPSEEK_API_KEY}
        export ANTHROPIC_MODEL=deepseek-chat
        export ANTHROPIC_SMALL_FAST_MODEL=deepseek-chat
        claude "$@"
    )
}


function vl() {
    nvim ~/dotfiles/.zshrc_local
}
function vz() {
    nvim ~/dotfiles/.zshrc_local
}
