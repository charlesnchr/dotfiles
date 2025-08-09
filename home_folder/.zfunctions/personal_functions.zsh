#!/bin/zsh

# alias for ssh to make panel naming for tmux
# ssh() {
#     if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
#         tmux rename-window "$(echo $* | cut -w -f 1)"
#         command ssh "$@"
#         tmux set-window-option automatic-rename "on" 1>/dev/null
#     else
#         command ssh "$@"
#     fi
# }

jcd() {
	cd "$(j -s | fzf | awk '{$1=""; print $0}' |  sed -e 's/^[ \t]*//')"; zsh
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


jog() {
    sqlite3 $HOME/.histdb/zsh-history.db "
    SELECT
        replace(commands.argv, '
        ', '
        ')
        FROM commands
        JOIN history ON history.command_id = commands.id
        JOIN places ON history.place_id = places.id
        WHERE history.exit_status = 0
        AND dir = '${PWD}'
        AND places.host = '${HOST}'
        AND commands.argv != 'jog'
        AND commands.argv NOT LIKE 'z %'
        AND commands.argv NOT LIKE 'cd %'
        AND commands.argv != '..'
        ORDER BY start_time DESC
        LIMIT 10
        "
    }

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
    unalias python

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
        source .venv/bin/activate

        if ! uv pip show python-lsp-server &> /dev/null; then
            uv pip install 'python-lsp-server[all]'
        fi

        if ! uv pip show pynvim &> /dev/null; then
            uv pip install pynvim
        fi

        export PYTHON_LSP_HOME=$(dirname $(which python))
    fi
}

function init_cargo() {
    export PATH="$HOME/.cargo/bin:$PATH"
    . "$HOME/.cargo/env"
}

