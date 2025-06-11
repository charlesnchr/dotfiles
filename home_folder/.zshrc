
# this gets rid of instant prompt warning when direnv does its thing
# see https://github.com/romkatv/powerlevel10k/issues/702#issuecomment-626222730
emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# needed if zmodule completion (zimfw) is not enabled
# autoload -U compinit && compinit -u

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

WORDCHARS=''
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|=*' \
  'l:|=* r:|=*'

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

AUTO_PUSHD="true"
DIRSTACKSIZE=15

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias vg="nvim -c Git -c only"
alias vimdiff='nvim -d'
alias ezsh="vi ~/.zshrc"
alias tdy="vi -c VimwikiMakeDiaryNote"
alias ydy="vi -c VimwikiMakeYesterdayDiaryNote"
alias tmrw="vi -c VimwikiMakeTomorrowDiaryNote"
alias vw="vi -c VimwikiIndex"
alias ttd="tt -n 10 -notheme -showwpm -csv >> ~/wpm.csv"
alias vcal="vi -c Calendar"
alias mux=tmuxinator
alias off="sleep 1; kscreen-doctor --dpms off"
alias xclip="xclip -selection clipboard"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

# Functions
# alias for ssh to make panel naming for tmux
ssh() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
        tmux rename-window "$(echo $* | cut -w -f 1)"
        command ssh "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
}

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

colo() {
    file_path=~/dotfiles/is_dark_mode
    [ ! -f "$file_path" ] || [ "$(cat "$file_path")" != 1 ] && echo 1 > "$file_path" || echo 0 > "$file_path"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# for correct tmux rendering over ssh from Windows
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# User configuration
# Author: Charles
# I have it after antigen because some packages will overwrite otherwise

source $HOME/bin/histdb-fzf-widget.sh

# zsh vi mode, toggle per-directory
function per-directory-history() {
  per-directory-history-toggle-history
}

# zsh vi mode -- uncomment this if used
# The plugin will auto execute this zvm_after_lazy_keybindings function
# function zvm_after_lazy_keybindings() {
#   zvm_define_widget per-directory-history
#   zvm_bindkey vicmd '^G' per-directory-history
#   zvm_bindkey vicmd '^F' histdb-fzf-widget
# }


# export PATH="$HOME/.poetry/bin:$PATH"

export BAT_THEME="Solarized (dark)"

# fd is much faster
# used for while:
# export FZF_DEFAULT_COMMAND='fd --type file -H'
# trying this to improve :Rg in vim
# export FZF_DEFAULT_COMMAND='fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,tags} --type file -H'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# configuring history
HISTORY_START_WITH_GLOBAL="true" # for per-directory-history plugin
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
unsetopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
unsetopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
unsetopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
unsetopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
unsetopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
unsetopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
unsetopt HIST_VERIFY               # Don't execute immediately upon history expansion.
unsetopt HIST_BEEP                 # Beep when accessing nonexistent history.

unsetopt HIST_IGNORE_DUPS
unsetopt HIST_FIND_NO_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_EXPIRE_DUPS_FIRST

setopt AUTOCD
setopt MENU_COMPLETE
zstyle ':completion:*' menu select

export VISUAL=nvim
export EDITOR=nvim
bindkey -e

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

function init_cargo() {
    export PATH="$HOME/.cargo/bin:$PATH"
    . "$HOME/.cargo/env"
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


# from ohmyzsh uv plugin (i don't want the plugin because it tries to manage generation of completions too)
alias uv="noglob uv"

alias uva='uv add'
alias uvexp='uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet'
alias uvl='uv lock'
alias uvlr='uv lock --refresh'
alias uvlu='uv lock --upgrade'
alias uvp='uv pip'
alias uvpy='uv python'
alias uvr='uv run'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvsr='uv sync --refresh'
alias uvsu='uv sync --upgrade'
alias uvup='uv self update'
alias uvv='uv venv'

zmodload -i zsh/complist

# i forgt what i need the below for:
#autoload -Uz add-zsh-hook
# init_cargo
# zprof

ZIM_HOME=~/.zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

source $HOME/dotfiles/.zshrc_local

autoload -Uz edit-command-line
zle -N edit-command-line

bindkey '^X^E' edit-command-line
bindkey '^R' histdb-fzf-widget
bindkey '^X^F' fzf-history-widget


# standard bash mapping (overrules delete whole line on macos)
bindkey "^U" backward-kill-line

# clash with tmux prefix
# bindkey '^Q' beginning-of-line

bindkey "\ea" beginning-of-line
bindkey "\ee" end-of-line

# Disable completion descriptions
zstyle ':completion:*:descriptions' format ''

