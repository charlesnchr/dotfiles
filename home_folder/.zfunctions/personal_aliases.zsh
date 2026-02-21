#!/bin/zsh

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
alias fabric='fabric-ai'
alias rm='rm -f'
alias pr='gh pr view --web'

# Unified usage reporting: Claude Code (ccusage), OpenClaw (JSONL), OpenCode (SQLite)
function allusage() {
  npx ccusage@latest "$@"
  python3 ~/bin/openclaw-jsonl-usage.py "$@"
  python3 ~/bin/opencode-sqlite-usage.py "$@"
}

alias a='opencode' # Claude Code alias
