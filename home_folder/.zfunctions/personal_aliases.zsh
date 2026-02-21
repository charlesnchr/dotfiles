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

# Unified usage reporting: Claude Code (ccusage), OpenClaw (JSONL), OpenCode (SQLite), OpenWhispr
function allusage() {
  local sources=("openclaw" "oc" "claw" "opencode" "oe" "code" "openwhispr" "ow" "whispr" "whisper")
  local skip_ccusage=false
  for arg in "$@"; do
    if (( ${sources[(Ie)${arg:l}]} )); then
      skip_ccusage=true
      break
    fi
  done
  if ! $skip_ccusage; then
    npx ccusage@latest "$@"
  fi
  python3 ~/bin/allusage.py "$@"
}

alias a='opencode' # Claude Code alias
