#!/usr/bin/env bash

# Setup script for Zellij migration from tmux

set -e

echo "🚀 Setting up Zellij configuration..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Zellij is installed
if ! command -v zellij &> /dev/null; then
    echo -e "${YELLOW}⚠️  Zellij is not installed.${NC}"
    echo ""
    echo "Please install Zellij first:"
    echo ""
    echo "  On macOS:"
    echo "    brew install zellij"
    echo ""
    echo "  On Linux:"
    echo "    cargo install --locked zellij"
    echo "    # or download binary from:"
    echo "    # https://github.com/zellij-org/zellij/releases"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓${NC} Zellij is installed: $(zellij --version)"
echo ""

# Create config directory
echo -e "${BLUE}→${NC} Creating Zellij config directory..."
mkdir -p ~/.config/zellij

# Symlink Zellij config
if [ -L ~/.config/zellij/config.kdl ]; then
    echo -e "${YELLOW}⚠️  Config already symlinked${NC}"
else
    echo -e "${BLUE}→${NC} Symlinking Zellij config..."
    ln -sf ~/dotfiles/home_folder/.config/zellij/config.kdl ~/.config/zellij/config.kdl
    echo -e "${GREEN}✓${NC} Config symlinked"
fi

# Symlink layouts directory
if [ -L ~/.config/zellij/layouts ]; then
    echo -e "${YELLOW}⚠️  Layouts already symlinked${NC}"
else
    echo -e "${BLUE}→${NC} Symlinking Zellij layouts..."
    ln -sf ~/dotfiles/home_folder/.config/zellij/layouts ~/.config/zellij/layouts
    echo -e "${GREEN}✓${NC} Layouts symlinked"
fi

# Symlink plugins directory
if [ -L ~/.config/zellij/plugins ]; then
    echo -e "${YELLOW}⚠️  Plugins already symlinked${NC}"
else
    echo -e "${BLUE}→${NC} Symlinking Zellij plugins..."
    ln -sf ~/dotfiles/home_folder/.config/zellij/plugins ~/.config/zellij/plugins
    echo -e "${GREEN}✓${NC} Plugins symlinked"
fi

# Create Ghostty config directory
echo ""
echo -e "${BLUE}→${NC} Setting up Ghostty config..."
mkdir -p ~/.config/ghostty

# Symlink Ghostty config
if [ -L ~/.config/ghostty/config ]; then
    echo -e "${YELLOW}⚠️  Ghostty config already symlinked${NC}"
else
    ln -sf ~/dotfiles/home_folder/.config/ghostty/config ~/.config/ghostty/config
    echo -e "${GREEN}✓${NC} Ghostty config symlinked"
fi

# Make sure all scripts are executable
echo ""
echo -e "${BLUE}→${NC} Making scripts executable..."
chmod +x ~/dotfiles/scripts/bin/zellij-*
echo -e "${GREEN}✓${NC} Scripts are executable"

# Check if scripts are in PATH
echo ""
if [[ ":$PATH:" == *":$HOME/dotfiles/scripts/bin:"* ]]; then
    echo -e "${GREEN}✓${NC} Scripts are in PATH"
else
    echo -e "${YELLOW}⚠️  Scripts directory not in PATH${NC}"
    echo ""
    echo "Add this to your shell config (~/.zshrc or ~/.bashrc):"
    echo ""
    echo "  export PATH=\"\$HOME/dotfiles/scripts/bin:\$PATH\""
    echo ""
fi

# Create cache directory
echo -e "${BLUE}→${NC} Creating cache directory..."
mkdir -p ~/.cache
echo -e "${GREEN}✓${NC} Cache directory ready"

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✓ Zellij setup complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Configuration files:"
echo "  • Config: ~/.config/zellij/config.kdl"
echo "  • Layouts: ~/.config/zellij/layouts/"
echo "  • Ghostty: ~/.config/ghostty/config"
echo ""
echo "Next steps:"
echo "  1. Start Zellij: ${BLUE}zellij${NC}"
echo "  2. Or attach to existing: ${BLUE}zellij attach${NC}"
echo "  3. Read the migration guide: ${BLUE}cat ~/dotfiles/ZELLIJ_MIGRATION.md${NC}"
echo ""
echo "Key bindings quick reference:"
echo "  • Sessionizer: ${BLUE}Ctrl+a o${NC}"
echo "  • Bookmark current: ${BLUE}Ctrl+a b${NC}"
echo "  • Quick switch: ${BLUE}Alt+1${NC} through ${BLUE}Alt+5${NC}"
echo "  • Create 5 tabs: ${BLUE}Ctrl+a Ctrl+w${NC}"
echo "  • Session overview: ${BLUE}Ctrl+a v${NC}"
echo ""
echo "Happy Zellij-ing! 🎉"
echo ""
