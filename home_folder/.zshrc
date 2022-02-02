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
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/tools/node-v14.15.4-linux-x64/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

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


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias vim="nvim"
alias vi="nvim"
alias vimdiff='nvim -d'
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias ttd="tt -n 10 -notheme -showwpm -csv >> ~/wpm.csv"
alias mux=tmuxinator

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


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source $HOME/dotfiles/.zshrc_local

# avoid spurious OA etc. https://superuser.com/questions/1265341/shell-sometimes-fails-to-output-esc-character-before-escape-sequence
bindkey "^[^[OA" up-line-or-beginning-search
bindkey "^[^[OB" down-line-or-beginning-search
bindkey "^[^[OC" forward-char
bindkey "^[^[OD" backward-char

bindkey '^Q' beginning-of-line

# standard bash mapping (overrules delete whole line on macos)
bindkey \^U backward-kill-line
# bindkey \^M kill-line


# antigen bundle MikeDacre/tmux-zsh-vim-titles
# antigen apply

# Functions
# alias for ssh to make panel naming for tmux
ssh() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
        tmux rename-window "$(echo $* | cut -d . -f 1)"
        command ssh "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
}

jcd() {
	cd "$(j -s | fzf | awk '{$1=""; print $0}' |  sed -e 's/^[ \t]*//')"
}

jvim() {
	file="$(AUTOJUMP_DATA_DIR=~/.autojump.vim/global autojump $@)"; if [ -n "$file" ]; then vim "$file"; fi
}

t() {
    [[ ! $(tmux a) ]] && tmuxinator Home
}

# function pywal {
#     # generate color scheme from current wallpaper
#     current_wallpaper="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"
#     wal -i $current_wallpaper -n
# }


# for correct tmux rendering over ssh from Windows
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

source $HOME/tools/antigen/antigen.zsh
antigen init $HOME/dotfiles/.antigenrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

