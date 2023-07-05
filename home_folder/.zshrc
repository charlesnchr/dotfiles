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


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias vimdiff='nvim -d'
alias ezsh="vi ~/.zshrc"
alias ei3="vi ~/.config/i3/config"
alias ei3s="vi ~/.config/i3status-rust/config.toml"
alias tdy="vi -c VimwikiMakeDiaryNote"
alias ydy="vi -c VimwikiMakeYesterdayDiaryNote"
alias tmrw="vi -c VimwikiMakeTomorrowDiaryNote"
alias vw="vi -c VimwikiIndex"
alias ttd="tt -n 10 -notheme -showwpm -csv >> ~/wpm.csv"
alias vc="vi -c Calendar"
alias mux=tmuxinator
alias off="xset dpms force off"
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


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

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

t() {
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


# for correct tmux rendering over ssh from Windows
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

source $HOME/tools/antigen/antigen.zsh
antigen init $HOME/dotfiles/.antigenrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


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


bindkey '^X^F' histdb-fzf-widget

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
export FZF_DEFAULT_COMMAND='fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,tags} --type file -H'
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


# Below is equivalent to
#   export LS_COLORS=$(vivid -m 8-bit generate solarized-dark)
# Uses https://github.com/sharkdp/vivid
export LS_COLORS="ca=0:so=1;38;5;168;48;5;254:sg=0:rs=0;38;5;246:st=0:pi=1;38;5;136;48;5;254:cd=1;38;5;136;48;5;254:su=0:*~=0;38;5;242:mi=1;38;5;167;48;5;254:ex=1;38;5;100:do=1;38;5;168;48;5;254:ow=0:tw=0:bd=1;38;5;136;48;5;254:mh=0:di=1;38;5;68:no=0;38;5;246:or=1;38;5;167;48;5;254:fi=0;38;5;246:ln=1;38;5;72:*.z=1;38;5;167:*.t=0;38;5;246:*.h=0;38;5;246:*.a=0;38;5;246:*.c=0;38;5;246:*.d=0;38;5;246:*.o=0;38;5;242:*.r=0;38;5;246:*.m=0;38;5;246:*.p=0;38;5;246:*.rs=0;38;5;246:*.gz=1;38;5;167:*.ps=0;38;5;166:*.nb=0;38;5;246:*.hs=0;38;5;246:*.bc=0;38;5;242:*.7z=1;38;5;167:*.jl=0;38;5;246:*.di=0;38;5;246:*.js=0;38;5;246:*.go=0;38;5;246:*.pp=0;38;5;246:*.ml=0;38;5;246:*.ui=0;38;5;246:*.cr=0;38;5;246:*.rb=0;38;5;246:*.lo=0;38;5;242:*.ll=0;38;5;246:*.pm=0;38;5;246:*.sh=0;38;5;246:*.rm=1;38;5;168:*.fs=0;38;5;246:*.cs=0;38;5;246:*css=0;38;5;246:*.wv=0;38;5;72:*.hi=0;38;5;242:*.cc=0;38;5;246:*.el=0;38;5;246:*.as=0;38;5;246:*.ko=0;38;5;246:*.gv=0;38;5;246:*.xz=1;38;5;167:*.md=0;38;5;246:*.ex=0;38;5;246:*.cp=0;38;5;246:*.kt=0;38;5;246:*.bz=1;38;5;167:*.td=0;38;5;246:*.hh=0;38;5;246:*.py=0;38;5;246:*.pl=0;38;5;246:*.la=0;38;5;242:*.vb=0;38;5;246:*.mn=0;38;5;246:*.so=0;38;5;246:*.ts=0;38;5;246:*.ico=0;38;5;168:*.nix=0;38;5;246:*.hpp=0;38;5;246:*.m4a=0;38;5;72:*.toc=0;38;5;242:*.dpr=0;38;5;246:*.tcl=0;38;5;246:*.csx=0;38;5;246:*.fls=0;38;5;242:*.blg=0;38;5;242:*.asa=0;38;5;246:*.rst=0;38;5;246:*.rar=1;38;5;167:*TODO=1;38;5;246:*.mov=1;38;5;168:*.ilg=0;38;5;242:*.sxw=0;38;5;166:*.pps=0;38;5;166:*.c++=0;38;5;246:*.ttf=0;38;5;62:*.png=0;38;5;168:*.swp=0;38;5;242:*.pyo=0;38;5;242:*.awk=0;38;5;246:*.git=0;38;5;242:*.kex=0;38;5;166:*.iso=1;38;5;167:*.sxi=0;38;5;166:*.tmp=0;38;5;242:*.dot=0;38;5;246:*.fsi=0;38;5;246:*.ppm=0;38;5;168:*.bz2=1;38;5;167:*.tif=0;38;5;168:*.sty=0;38;5;242:*.pyc=0;38;5;242:*.cpp=0;38;5;246:*.bbl=0;38;5;242:*.mli=0;38;5;246:*.ipp=0;38;5;246:*.svg=0;38;5;168:*.bak=0;38;5;242:*.cxx=0;38;5;246:*.def=0;38;5;246:*.pgm=0;38;5;168:*.dox=0;38;5;246:*.bag=1;38;5;167:*.elm=0;38;5;246:*.hxx=0;38;5;246:*.swf=1;38;5;168:*.aif=0;38;5;72:*.aux=0;38;5;242:*.htm=0;38;5;246:*.xls=0;38;5;166:*.tsx=0;38;5;246:*.pas=0;38;5;246:*.xcf=0;38;5;168:*.deb=1;38;5;167:*.exs=0;38;5;246:*.vcd=1;38;5;167:*.mpg=1;38;5;168:*.ppt=0;38;5;166:*.ogg=0;38;5;72:*.m4v=1;38;5;168:*.epp=0;38;5;246:*.pyd=0;38;5;242:*.bib=0;38;5;246:*.avi=1;38;5;168:*.bst=0;38;5;246:*.odp=0;38;5;166:*.jpg=0;38;5;168:*.eps=0;38;5;168:*.rpm=1;38;5;167:*.kts=0;38;5;246:*.yml=0;38;5;246:*.tar=1;38;5;167:*.inl=0;38;5;246:*.tex=0;38;5;246:*.bsh=0;38;5;246:*.com=0;38;5;246:*.php=0;38;5;246:*.mir=0;38;5;246:*.cfg=0;38;5;246:*.flv=1;38;5;168:*.mp3=0;38;5;72:*.fon=0;38;5;62:*.apk=1;38;5;167:*.img=1;38;5;167:*.htc=0;38;5;246:*.clj=0;38;5;246:*.fsx=0;38;5;246:*.jar=1;38;5;167:*.tgz=1;38;5;167:*.lua=0;38;5;246:*.sql=0;38;5;246:*.csv=0;38;5;246:*.wma=0;38;5;72:*.pid=0;38;5;242:*.bmp=0;38;5;168:*.zst=1;38;5;167:*.pbm=0;38;5;168:*.otf=0;38;5;62:*.bin=1;38;5;167:*.zip=1;38;5;167:*hgrc=0;38;5;246:*.h++=0;38;5;246:*.mkv=1;38;5;168:*.vob=1;38;5;168:*.xml=0;38;5;246:*.doc=0;38;5;166:*.dmg=1;38;5;167:*.ps1=0;38;5;246:*.exe=0;38;5;246:*.bat=0;38;5;246:*.ind=0;38;5;242:*.rtf=0;38;5;166:*.xmp=0;38;5;246:*.pro=0;38;5;246:*.mid=0;38;5;72:*.odt=0;38;5;166:*.tbz=1;38;5;167:*.psd=0;38;5;168:*.out=0;38;5;242:*.txt=0;38;5;246:*.mp4=1;38;5;168:*.zsh=0;38;5;246:*.inc=0;38;5;246:*.pod=0;38;5;246:*.ltx=0;38;5;246:*.bcf=0;38;5;242:*.dll=0;38;5;246:*.cgi=0;38;5;246:*.pkg=1;38;5;167:*.log=0;38;5;242:*.ods=0;38;5;166:*.wav=0;38;5;72:*.tml=0;38;5;246:*.pdf=0;38;5;166:*.idx=0;38;5;242:*.ini=0;38;5;246:*.arj=1;38;5;167:*.vim=0;38;5;246:*.xlr=0;38;5;166:*.gvy=0;38;5;246:*.wmv=1;38;5;168:*.ics=0;38;5;166:*.erl=0;38;5;246:*.sbt=0;38;5;246:*.fnt=0;38;5;62:*.gif=0;38;5;168:*.orig=0;38;5;242:*.h264=1;38;5;168:*.json=0;38;5;246:*.mpeg=1;38;5;168:*.conf=0;38;5;246:*.bash=0;38;5;246:*.tiff=0;38;5;168:*.webm=1;38;5;168:*.make=0;38;5;246:*.dart=0;38;5;246:*.java=0;38;5;246:*.opus=0;38;5;72:*.psm1=0;38;5;246:*.jpeg=0;38;5;168:*.psd1=0;38;5;246:*.hgrc=0;38;5;246:*.toml=0;38;5;246:*.rlib=0;38;5;242:*.epub=0;38;5;166:*.yaml=0;38;5;246:*.tbz2=1;38;5;167:*.lock=0;38;5;242:*.lisp=0;38;5;246:*.docx=0;38;5;166:*.purs=0;38;5;246:*.html=0;38;5;246:*.xlsx=0;38;5;166:*.fish=0;38;5;246:*.flac=0;38;5;72:*.diff=0;38;5;246:*.pptx=0;38;5;166:*.less=0;38;5;246:*README=0;38;5;246:*.xhtml=0;38;5;246:*.scala=0;38;5;246:*.patch=0;38;5;246:*.cmake=0;38;5;246:*shadow=0;38;5;246:*.class=0;38;5;242:*.toast=1;38;5;167:*.swift=0;38;5;246:*.mdown=0;38;5;246:*.dyn_o=0;38;5;242:*.cache=0;38;5;242:*.ipynb=0;38;5;246:*.cabal=0;38;5;246:*.shtml=0;38;5;246:*passwd=0;38;5;246:*.matlab=0;38;5;246:*.ignore=0;38;5;246:*.config=0;38;5;246:*INSTALL=0;38;5;246:*LICENSE=0;38;5;246:*.gradle=0;38;5;246:*.groovy=0;38;5;246:*COPYING=0;38;5;246:*.dyn_hi=0;38;5;242:*.flake8=0;38;5;246:*TODO.md=1;38;5;246:*Doxyfile=0;38;5;246:*Makefile=0;38;5;246:*TODO.txt=1;38;5;246:*setup.py=0;38;5;246:*.desktop=0;38;5;246:*.gemspec=0;38;5;246:*configure=0;38;5;246:*.kdevelop=0;38;5;246:*COPYRIGHT=0;38;5;246:*.cmake.in=0;38;5;246:*.DS_Store=0;38;5;242:*README.md=0;38;5;246:*.markdown=0;38;5;246:*.fdignore=0;38;5;246:*.rgignore=0;38;5;246:*CODEOWNERS=0;38;5;246:*.gitconfig=0;38;5;246:*.gitignore=0;38;5;246:*Dockerfile=0;38;5;246:*.scons_opt=0;38;5;242:*SConstruct=0;38;5;246:*.localized=0;38;5;242:*SConscript=0;38;5;246:*README.txt=0;38;5;246:*INSTALL.md=0;38;5;246:*Makefile.am=0;38;5;246:*.synctex.gz=0;38;5;242:*MANIFEST.in=0;38;5;246:*.travis.yml=0;38;5;246:*.gitmodules=0;38;5;246:*INSTALL.txt=0;38;5;246:*LICENSE-MIT=0;38;5;246:*Makefile.in=0;38;5;242:*.fdb_latexmk=0;38;5;242:*CONTRIBUTORS=0;38;5;246:*.applescript=0;38;5;246:*appveyor.yml=0;38;5;246:*configure.ac=0;38;5;246:*.clang-format=0;38;5;246:*CMakeLists.txt=0;38;5;246:*.gitattributes=0;38;5;246:*LICENSE-APACHE=0;38;5;246:*CMakeCache.txt=0;38;5;242:*CONTRIBUTORS.md=0;38;5;246:*requirements.txt=0;38;5;246:*.sconsign.dblite=0;38;5;242:*CONTRIBUTORS.txt=0;38;5;246:*package-lock.json=0;38;5;242:*.CFUserTextEncoding=0;38;5;242"

# alias ls="gls --color"


source $HOME/dotfiles/.zshrc_local
