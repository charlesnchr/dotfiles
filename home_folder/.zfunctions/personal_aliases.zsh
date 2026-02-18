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

# Unified Claude usage reporting: syncs OpenClaw data then runs ccusage over both
function allusage() {
  ~/.openclaw/bin/openclaw-ccusage-sync
  CLAUDE_CONFIG_DIR="$HOME/.claude,$HOME/.openclaw/ccusage-compat" npx ccusage@latest "$@"
}
