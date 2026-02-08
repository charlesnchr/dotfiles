#!/usr/bin/env bash
set -euo pipefail

log() { printf "[nixos-install] %s\n" "$*"; }

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

need sudo
need nix

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
MODULE_SRC="$DOTFILES_DIR/nixos/cc-dotfiles.nix"
MODULE_DST="/etc/nixos/cc-dotfiles.nix"
CONFIG="/etc/nixos/configuration.nix"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  log "dotfiles not found at $DOTFILES_DIR"
  log "clone it first, e.g.: nix-shell -p git --run 'git clone https://github.com/charlesnchr/dotfiles.git $DOTFILES_DIR'"
  exit 1
fi

if [[ ! -f "$MODULE_SRC" ]]; then
  echo "missing module: $MODULE_SRC" >&2
  exit 1
fi

log "installing NixOS module: $MODULE_DST"
sudo install -m 0644 "$MODULE_SRC" "$MODULE_DST"

if ! sudo grep -q "cc-dotfiles\\.nix" "$CONFIG" >/dev/null 2>&1; then
  log "adding module import to $CONFIG"
  ts="$(date +%Y%m%d-%H%M%S)"
  sudo cp "$CONFIG" "$CONFIG.bak-$ts"
  sudo awk '
    BEGIN{inImports=0; inserted=0}
    {
      if (!inserted && $0 ~ /^[[:space:]]*imports[[:space:]]*=/) { inImports=1 }
      if (inImports && !inserted && $0 ~ /^[[:space:]]*];[[:space:]]*$/) {
        print "    ./cc-dotfiles.nix"
        inserted=1
        inImports=0
      }
      print
    }
  ' "$CONFIG" | sudo tee "$CONFIG.tmp" >/dev/null
  sudo mv "$CONFIG.tmp" "$CONFIG"
  sudo grep -q "cc-dotfiles\\.nix" "$CONFIG"
fi

log "nixos-rebuild switch"
sudo nixos-rebuild switch

log "stowing dotfiles"
need stow
mkdir -p "$HOME/.config" "$HOME/bin"
(
  cd "$DOTFILES_DIR"
  stow -v home_folder
  stow -v nvim
  stow -v scripts
)

log "setting login shell to zsh"
sudo chsh -s "$(command -v zsh)" "$USER" || true

log "setting up zimfw (via ~/.zshrc)"
zsh -lc 'source ~/.zshrc >/dev/null 2>&1 || true'

log "tmux plugins (TPM)"
mkdir -p "$HOME/.tmux/plugins"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
tmux start-server || true
tmux new-session -d -s _tpm_bootstrap || true
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all || true
tmux kill-session -t _tpm_bootstrap >/dev/null 2>&1 || true
tmux kill-server >/dev/null 2>&1 || true

log "fzf bindings"
if [[ ! -f "$HOME/.fzf.zsh" ]]; then
  fzf --zsh >"$HOME/.fzf.zsh"
fi

log "node (fnm) + yarn (corepack)"
eval "$(fnm env --use-on-cd)"
fnm install 22 >/dev/null 2>&1 || true
fnm default 22
corepack enable --install-directory "$HOME/.local/bin" || true
corepack prepare yarn@1.22.22 --activate || true

log "claude"
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

log "python (pyenv) + pynvim"
eval "$(pyenv init -)"
# pyenv may print versions with leading spaces depending on context; normalize.
if ! pyenv versions --bare | tr -d '[:space:]' | grep -q '^3\.12'; then
  if ! pyenv install 3.12; then
    log "pyenv install failed; retrying with nix-shell build deps"
    nix-shell -p zlib.dev bzip2.dev openssl.dev readline.dev sqlite.dev ncurses.dev xz.dev tk.dev libffi.dev pkg-config gcc gnumake --run "pyenv install 3.12"
  fi
fi
pyenv global 3.12
eval "$(pyenv init -)"
pip install -U pip pynvim

log "neovim plugins"
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

log "done"
