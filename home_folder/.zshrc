# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Auto-start Tmux (works better than omz plugin)
# if [ "$TMUX" = "" ]; then tmux; fi

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# ---  commented out in favour of antigen
# export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ---  commented out in favour of antigen
# ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="agnoster"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"


# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# ZSH_TMUX_AUTOSTART="true"
# ZSH_TMUX_AUTOSTART_ONCE="false"
# ZSH_TMUX_ITERM2="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# ---  commented out in favour of antigen
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting k zsh-navigation-tools fasd ranger-autojump tmux)

# ---  commented out in favour of antigen
# source $ZSH/oh-my-zsh.sh


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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
alias vg="nvim -c Git"
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

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# ---  commented out in favour of antigen
# source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
# autoload -Uz add-zsh-hook

# for ranger
export VISUAL=nvim;
export EDITOR=nvim;


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

source $HOME/tools/antigen/antigen.zsh
antigen init $HOME/dotfiles/.antigenrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# avoid spurious OA etc. https://superuser.com/questions/1265341/shell-sometimes-fails-to-output-esc-character-before-escape-sequence
# bindkey "^[^[OA" up-line-or-beginning-search
# bindkey "^[^[OB" down-line-or-beginning-search
# bindkey "^[^[OC" forward-char
# bindkey "^[^[OD" backward-char

# antigen bundle MikeDacre/tmux-zsh-vim-titles
# antigen apply

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

function conda_activate() {
    # Activate the conda environment
    conda activate "$1"

    # Check if python-lsp-server[all] is installed, if not install it
    if ! pip show python-lsp-server &> /dev/null; then
        pip install 'python-lsp-server[all]'
    fi

    # Check if pynvim is installed, if not install it
    if ! pip show pynvim &> /dev/null; then
        pip install pynvim
    fi

    # Set PYTHON_LSP_HOME environment variable
    export PYTHON_LSP_HOME=$(dirname $(which python))
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


bindkey '^R' histdb-fzf-widget
bindkey '^X^F' fzf-history-widget

setopt menu_complete

# standard bash mapping (overrules delete whole line on macos)
bindkey "^U" backward-kill-line

# clash with tmux prefix
# bindkey '^Q' beginning-of-line

# does not seem to work
# bindkey '^X^A' beginning-of-line
bindkey "\ea" beginning-of-line
bindkey "\ee" end-of-line


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
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


source $HOME/dotfiles/.zshrc_local
autoload -Uz add-zsh-hook


eval "$(pyenv init -)"

. "$HOME/.cargo/env"
