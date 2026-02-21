#!/bin/bash
#
# Streamlined dotfiles installation for macOS and Linux
# Uses Homebrew as the common package manager substrate
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"
info "Detected: $OS ($ARCH)"

# ==============================================================================
# Phase 1: System packages (requires sudo on Linux)
# ==============================================================================

if [[ "$OS" == "Linux" ]]; then
    info "Installing Linux system essentials via apt..."
    sudo apt update
    sudo apt install -y \
        zsh tmux git curl wget \
        build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev \
        sqlite3 jq stow ranger zip unzip
fi

# ==============================================================================
# Phase 2: Homebrew (common substrate for macOS and Linux)
# ==============================================================================

if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for this session
    if [[ "$OS" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$OS" == "Darwin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    info "Homebrew already installed"
fi

# ==============================================================================
# Phase 3: Core tools via Homebrew
# ==============================================================================

info "Installing core tools via Homebrew..."
brew install \
    neovim \
    pyenv \
    uv \
    fnm \
    fzf \
    ripgrep \
    fd \
    bat \
    zoxide \
    direnv \
    gh \
    atuin \
    zoxide \
    tmuxinator \
    universal-ctags

# Set up fnm with Node LTS
info "Setting up Node via fnm..."
eval "$(fnm env)"
if ! fnm list | grep -q "v22"; then
    fnm install 22
fi
fnm default 22

# ==============================================================================
# Phase 4: Claude Code (via official installer, not brew)
# ==============================================================================

if ! command -v claude &> /dev/null; then
    info "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    info "Claude Code already installed"
fi

# Install Claude Code hooks (tmux status emojis + notifications)
if [ -x "$HOME/.claude/hooks/install-hooks.sh" ]; then
    info "Installing Claude Code hooks..."
    "$HOME/.claude/hooks/install-hooks.sh"
fi

# ==============================================================================
# Phase 4b: find-session (unified session finder for Claude/Codex/OpenCode)
# ==============================================================================

info "Installing find-session..."
uv tool install --force "find-session @ git+https://github.com/charlesnchr/find-session"

# ==============================================================================
# Phase 5: Python setup
# ==============================================================================

info "Setting up Python via pyenv..."
eval "$(pyenv init -)"
if ! pyenv versions | grep -q "3.12"; then
    pyenv install 3.12
fi
pyenv global 3.12

# Rehash to pick up the new Python
eval "$(pyenv init -)"

# Install pynvim for neovim Python support
info "Installing pynvim..."
pip install -U pynvim

# ==============================================================================
# Phase 6: Dotfiles symlinks
# ==============================================================================

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

info "Setting up dotfiles symlinks..."
mkdir -p ~/.config

# Use stow if available, otherwise manual symlinks
if command -v stow &> /dev/null; then
    stow -v home_folder
    stow -v nvim
    mkdir -p ~/bin
    stow -v scripts
else
    warn "stow not found, using manual symlinks..."
    ln -sfn "$DOTFILES_DIR/home_folder/.zshrc" ~/.zshrc
    ln -sfn "$DOTFILES_DIR/home_folder/.zshenv" ~/.zshenv
    ln -sfn "$DOTFILES_DIR/home_folder/.zimrc" ~/.zimrc
    ln -sfn "$DOTFILES_DIR/home_folder/.tmux.conf" ~/.tmux.conf
    ln -sfn "$DOTFILES_DIR/home_folder/.vimrc" ~/.vimrc
    ln -sfn "$DOTFILES_DIR/home_folder/.vim" ~/.vim
    ln -sfn "$DOTFILES_DIR/home_folder/.config/ranger" ~/.config/ranger
    ln -sfn "$DOTFILES_DIR/nvim/.config/nvim" ~/.config/nvim
    ln -sfn "$DOTFILES_DIR/scripts/bin" ~/bin
fi

# ==============================================================================
# Phase 7: Zsh setup (zimfw)
# ==============================================================================

if [[ ! -d "$HOME/.zim" ]]; then
    info "Installing zimfw..."
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
else
    info "zimfw already installed"
fi

# ==============================================================================
# Phase 8: Tmux plugins
# ==============================================================================

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    info "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    info "Run 'prefix + I' in tmux to install plugins"
else
    info "tmux plugin manager already installed"
fi

# ==============================================================================
# Phase 9: fzf key bindings
# ==============================================================================

if [[ ! -f "$HOME/.fzf.zsh" ]]; then
    info "Setting up fzf key bindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# ==============================================================================
# Phase 10: Neovim plugins
# ==============================================================================

info "Setting up Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

# ==============================================================================
# Done
# ==============================================================================

echo ""
info "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Change default shell: chsh -s \$(which zsh)"
echo "  2. Log out and back in (or run: exec zsh)"
echo "  3. In tmux, press prefix + I to install plugins"
echo ""
