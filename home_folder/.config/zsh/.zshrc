# this gets rid of instant prompt warning when direnv does its thing
# see https://github.com/romkatv/powerlevel10k/issues/702#issuecomment-626222730
emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export VISUAL=nvim
export EDITOR=nvim

# this is for oh-my-zsh completions
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
mkdir -p "$ZSH_CACHE_DIR/completions"

# needed if zmodule completion (zimfw) is not enabled
# autoload -Uz compinit && compinit -u
# for antidote use: mattmc3/ez-compinit

WORDCHARS=''

HIST_STAMPS="mm/dd/yyyy"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

# for correct tmux rendering over ssh from Windows
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


source $HOME/bin/histdb-fzf-widget.sh

export BAT_THEME="Solarized (dark)"

# fd is much faster
export FZF_DEFAULT_COMMAND='fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,tags} --type file -H'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS
# Prevent background jobs being given a lower priority.
setopt NO_BG_NICE
# Prevent status report of jobs on shell exit.
setopt NO_CHECK_JOBS
# Prevent SIGHUP to jobs on shell exit.
setopt NO_HUP


HISTORY_START_WITH_GLOBAL="true" # for per-directory-history plugin
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt NO_BANG_HIST
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.

setopt MENU_COMPLETE

zmodload -i zsh/complist

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

# key bindings
bindkey -e # emacs bindings - needs to be above custom



# standard bash mapping (overrules delete whole line on macos)
bindkey "^U" backward-kill-line

# clash with tmux prefix
# bindkey '^Q' beginning-of-line

bindkey "\ea" beginning-of-line
bindkey "\ee" end-of-line

# Disable completion descriptions
zstyle ':completion:*:descriptions' format ''

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

_evalcache pyenv init -
_evalcache fnm env
_evalcache direnv hook zsh
_evalcache zoxide init zsh
_evalcache fzf --zsh

bindkey '^X^E' edit-command-line
bindkey '^X^F' fzf-history-widget
bindkey '^R' histdb-fzf-widget
