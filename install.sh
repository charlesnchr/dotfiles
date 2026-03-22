#!/bin/bash
#
# Idempotent dotfiles installation for macOS and Linux
# Uses Homebrew as the common package manager substrate
# Safe to re-run: each phase runs independently, failures don't block later phases
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Phase tracking
PHASE_RESULTS=()
run_phase() {
    local name="$1"
    shift
    info "=== $name ==="
    if "$@"; then
        PHASE_RESULTS+=("${GREEN}✓${NC} $name")
    else
        PHASE_RESULTS+=("${RED}✗${NC} $name")
        warn "$name failed — continuing"
    fi
}

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"
info "Detected: $OS ($ARCH)"

# ==============================================================================
# Phase 1: System packages (requires sudo on Linux)
# ==============================================================================

phase_system_packages() {
    [[ "$OS" != "Linux" ]] && return 0
    sudo apt update
    sudo apt install -y \
        zsh tmux git curl wget \
        build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev \
        sqlite3 jq stow ranger zip unzip
}

# ==============================================================================
# Phase 2: Homebrew (common substrate for macOS and Linux)
# ==============================================================================

phase_homebrew() {
    if command -v brew &> /dev/null; then
        info "Homebrew already installed"
        return 0
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ "$OS" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$OS" == "Darwin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# ==============================================================================
# Phase 3: Core tools via Homebrew
# ==============================================================================

phase_brew_packages() {
    if ! command -v brew &> /dev/null; then
        if [[ "$OS" == "Linux" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        elif [[ "$OS" == "Darwin" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

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
        stow \
        tmuxinator \
        universal-ctags

    if [[ "$OS" == "Darwin" ]]; then
        brew install --cask nikitabobko/tap/aerospace
    fi
}

# ==============================================================================
# Phase 4: Node via fnm
# ==============================================================================

phase_node() {
    eval "$(fnm env)"
    if ! fnm list | grep -q "v22"; then
        fnm install 22
    fi
    fnm default 22
}

# ==============================================================================
# Phase 5: Claude Code
# ==============================================================================

phase_claude() {
    if ! command -v claude &> /dev/null; then
        curl -fsSL https://claude.ai/install.sh | bash
    else
        info "Claude Code already installed"
    fi

    if [ -x "$HOME/.claude/hooks/install-hooks.sh" ]; then
        "$HOME/.claude/hooks/install-hooks.sh"
    fi
}

# ==============================================================================
# Phase 6: coding-agent-tools
# ==============================================================================

phase_coding_agent_tools() {
    uv tool install --force coding-agent-tools
}

# ==============================================================================
# Phase 7: Python setup
# ==============================================================================

phase_python() {
    eval "$(pyenv init -)"
    if ! pyenv versions | grep -q "3.12"; then
        pyenv install 3.12
    fi
    pyenv global 3.12
    eval "$(pyenv init -)"
    pip install -U pynvim
}

# ==============================================================================
# Phase 8: Dotfiles symlinks
# ==============================================================================

phase_symlinks() {
    local dotfiles_dir="$HOME/dotfiles"
    cd "$dotfiles_dir"
    mkdir -p ~/.config

    stow -v --adopt home_folder
    stow -v --adopt nvim
    mkdir -p ~/bin
    stow -v --adopt scripts
    if [[ "$OS" == "Darwin" ]]; then
        stow -v --adopt home_folder_macos
    fi

    # Restore dotfiles repo versions after --adopt pulled in local changes
    cd "$dotfiles_dir"
    git checkout .
}

# ==============================================================================
# Phase 9: Compile Swift utilities (macOS only)
# ==============================================================================

phase_swift_utils() {
    [[ "$OS" != "Darwin" ]] && return 0
    local src="$HOME/dotfiles/scripts/bin"
    local dst="$HOME/bin"
    mkdir -p "$dst"

    for swift_file in "$src"/*.swift; do
        [ -f "$swift_file" ] || continue
        local name
        name="$(basename "${swift_file%.swift}")"
        local bin="$dst/$name"
        if [ "$swift_file" -nt "$bin" ] || [ ! -f "$bin" ]; then
            info "Compiling $name"
            swiftc -O -o "$bin" "$swift_file"
        else
            info "$name already up to date"
        fi
    done
}

# ==============================================================================
# Phase 10: macOS Raycast scripts
# ==============================================================================

phase_raycast() {
    [[ "$OS" != "Darwin" ]] && return 0
    mkdir -p "$HOME/raycast-scripts/dotfiles/images"
    cp -f "$HOME/bin/raycast-scripts/message-woodhouse.sh" "$HOME/raycast-scripts/dotfiles/message-woodhouse.sh"
    cp -f "$HOME/bin/raycast-scripts/images/woodhouse.png" "$HOME/raycast-scripts/dotfiles/images/woodhouse.png"
    chmod +x "$HOME/raycast-scripts/dotfiles/message-woodhouse.sh"
}

# ==============================================================================
# Phase 11: Zsh (zimfw)
# ==============================================================================

phase_zsh() {
    if [[ ! -d "$HOME/.zim" ]]; then
        curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    else
        info "zimfw already installed"
    fi
}

# ==============================================================================
# Phase 12: Tmux plugins
# ==============================================================================

phase_tmux() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        info "tmux plugin manager already installed"
    fi
}

# ==============================================================================
# Phase 13: fzf key bindings
# ==============================================================================

phase_fzf() {
    if [[ ! -f "$HOME/.fzf.zsh" ]]; then
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
    else
        info "fzf key bindings already set up"
    fi
}

# ==============================================================================
# Phase 14: Neovim plugins
# ==============================================================================

phase_neovim() {
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
}

# ==============================================================================
# Run all phases
# ==============================================================================

run_phase "System packages"       phase_system_packages
run_phase "Homebrew"              phase_homebrew
run_phase "Brew packages"         phase_brew_packages
run_phase "Node (fnm)"            phase_node
run_phase "Claude Code"           phase_claude
run_phase "coding-agent-tools"    phase_coding_agent_tools
run_phase "Python (pyenv)"        phase_python
run_phase "Dotfiles symlinks"     phase_symlinks
run_phase "Swift utilities"       phase_swift_utils
run_phase "Raycast scripts"       phase_raycast
run_phase "Zsh (zimfw)"           phase_zsh
run_phase "Tmux plugins"          phase_tmux
run_phase "fzf key bindings"      phase_fzf
run_phase "Neovim plugins"        phase_neovim

# ==============================================================================
# Summary
# ==============================================================================

echo ""
info "=== Summary ==="
for result in "${PHASE_RESULTS[@]}"; do
    echo -e "  $result"
done
echo ""
echo "Next steps:"
echo "  1. Change default shell: chsh -s \$(which zsh)"
echo "  2. Log out and back in (or run: exec zsh)"
echo "  3. In tmux, press prefix + I to install plugins"
echo ""
