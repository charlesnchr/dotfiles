# Tmux to Zellij Migration Guide

This guide explains the migration of your tmux configuration to Zellij, including all custom functionality.

## Overview

All your tmux functionality has been ported to Zellij:

✅ Session management with sessionizer and fzf
✅ Bookmark bar showing 5 quick-access sessions
✅ Quick session switching (Alt+1 through Alt+5)
✅ Custom window/tab creation (5 tabs: zsh, ranger, nvim, claude, log)
✅ Vim-like navigation and resizing
✅ All custom keybindings
✅ Virtual session overview grid
✅ Ghostty integration

## Installation

### 1. Install Zellij

```bash
# On macOS
brew install zellij

# On Linux
cargo install --locked zellij
# or
wget https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar -xzf zellij-x86_64-unknown-linux-musl.tar.gz
sudo mv zellij /usr/local/bin/
```

### 2. Symlink Configuration Files

```bash
# Zellij config
ln -sf ~/dotfiles/home_folder/.config/zellij ~/.config/zellij

# Ghostty config
ln -sf ~/dotfiles/home_folder/.config/ghostty ~/.config/ghostty

# Make sure all scripts are in your PATH
# (scripts are in ~/dotfiles/scripts/bin)
```

### 3. Start Zellij

```bash
zellij
```

Or configure Ghostty to auto-start Zellij (uncomment last line in ghostty config).

## Key Bindings Mapping

### Prefix Key
- **Tmux**: `Ctrl+a` or `Ctrl+q`
- **Zellij**: `Ctrl+a` or `Ctrl+q` (same!)

### Session Management

| Function | Tmux | Zellij |
|----------|------|--------|
| Sessionizer | `Ctrl+a o` | `Ctrl+a o` |
| Quick bookmark 1-5 | `Alt+1` to `Alt+5` | `Alt+1` to `Alt+5` |
| Bookmark current | `Ctrl+a b` | `Ctrl+a b` |
| Set bookmark slot | `Ctrl+a B <1-5>` | `Ctrl+a B <1-5>` |
| Clear all bookmarks | `Ctrl+a B \`` | `Ctrl+a B \`` |
| Session overview | N/A | `Ctrl+a v` |
| Switch to last | `Ctrl+a Ctrl+b` | `Ctrl+a Ctrl+b` |

### Pane Navigation

| Function | Tmux | Zellij |
|----------|------|--------|
| Move up | `Ctrl+a Ctrl+k` | `Ctrl+a Ctrl+k` or `Alt+k` |
| Move down | `Ctrl+a Ctrl+j` | `Ctrl+a Ctrl+j` or `Alt+j` |
| Move left | `Ctrl+a Ctrl+h` | `Ctrl+a Ctrl+h` or `Alt+h` |
| Move right | `Ctrl+a Ctrl+l` | `Ctrl+a Ctrl+l` or `Alt+l` |
| Toggle fullscreen | `Ctrl+a /` or `Ctrl+a Ctrl+i` | `Ctrl+a /` or `Ctrl+a Ctrl+i` |
| Last pane | `Ctrl+a /` | `Ctrl+a /` |

### Pane Resizing

| Function | Tmux | Zellij |
|----------|------|--------|
| Resize up | `Ctrl+a K` | `Ctrl+a K` |
| Resize down | `Ctrl+a J` | `Ctrl+a J` |
| Resize left | `Ctrl+a H` | `Ctrl+a H` |
| Resize right | `Ctrl+a L` | `Ctrl+a L` |

### Window/Tab Management

| Function | Tmux | Zellij |
|----------|------|--------|
| New window/tab | `Ctrl+a c` | `Ctrl+a c` |
| Close window/tab | `Ctrl+a x` | `Ctrl+a x` |
| Rename window/tab | `Ctrl+a ,` | `Ctrl+a ,` |
| Last window/tab | `Ctrl+a Ctrl+o` | `Ctrl+a Ctrl+o` |
| Go to last window | `Ctrl+a 9` | `Ctrl+a 9` |
| Create 5 windows | `Ctrl+a Ctrl+w` | `Ctrl+a Ctrl+w` |

### Quick Tab Access

| Function | Tmux | Zellij |
|----------|------|--------|
| Go to/create ranger | `Ctrl+a Ctrl+r` | `Ctrl+a Ctrl+r` |
| Go to/create nvim | `Ctrl+a Ctrl+e` | `Ctrl+a Ctrl+e` |
| Go to/create zsh | `Ctrl+a Ctrl+t` | `Ctrl+a Ctrl+t` |

### Other

| Function | Tmux | Zellij |
|----------|------|--------|
| Reload config | `Ctrl+a r` | `Ctrl+a r` |
| Command prompt | `Ctrl+a ;` | `Ctrl+a ;` |

## File Locations

### Configuration Files
- Main config: `~/.config/zellij/config.kdl`
- Layouts: `~/.config/zellij/layouts/`
  - `default.kdl` - Default layout with bookmark bar
  - `simple.kdl` - Simple layout without bookmark bar
  - `overview.kdl` - Virtual session overview layout
- Ghostty config: `~/.config/ghostty/config`

### Scripts
All scripts are in `~/dotfiles/scripts/bin/`:
- `zellij-sessionizer` - Interactive session selector
- `zellij-switch-to-recent` - Switch to bookmarked session
- `zellij-bookmark-add` - Bookmark current session
- `zellij-bookmark-session` - Set bookmark at specific slot
- `zellij-bookmark-clear-all` - Clear all bookmarks
- `zellij-show-bookmarks` - Display bookmark bar
- `zellij-create-tabs` - Create 5 standard tabs
- `zellij-goto-or-create-tab` - Go to or create named tab
- `zellij-launch-overview` - Launch virtual session overview
- `zellij-session-overview` - Display session in overview grid

### Cache Files
- `~/.cache/zellij-session-bookmarks` - Session bookmarks
- `~/.cache/tmux-sessionizer-all-dirs` - Cached project directories (shared with tmux)
- `~/.cache/tmux-sessionizer-branches` - Git branch cache (shared with tmux)

## New Features (Not in Tmux)

### Virtual Session Overview
Press `Ctrl+a v` to launch a special "overview" session that displays all 5 bookmarked sessions in a grid layout, plus a dedicated Claude pane that's shared across all sessions.

This gives you a bird's-eye view of all your active sessions without switching between them.

### Better Session Switching
Zellij sessions are lighter and faster to create/switch than tmux sessions. The sessionizer is even faster now.

### Built-in Mouse Support
Click on tabs, panes, and status bar elements to interact with them.

## Customization

### Change Layouts
Edit `~/.config/zellij/layouts/default.kdl` to customize your default layout.

To disable the bookmark bar, use the simple layout:
```bash
zellij -l simple
```

### Modify Keybindings
Edit `~/.config/zellij/config.kdl` and modify the `keybinds` section.

### Theme Changes
The Gruvbox Dark theme is configured in `config.kdl`. To change it, modify the `themes` section or use one of Zellij's built-in themes.

## Troubleshooting

### Scripts Not Found
Make sure `~/dotfiles/scripts/bin` is in your PATH:
```bash
export PATH="$HOME/dotfiles/scripts/bin:$PATH"
```

### Bookmark Bar Not Showing
If the bookmark bar doesn't appear, check that:
1. `zellij-bookmark-bar-loop` is executable
2. The default layout is being used
3. Try switching layouts: `zellij action load-layout ~/.config/zellij/layouts/default.kdl`

### Keybindings Not Working
1. Make sure Ghostty is configured to pass through Ctrl+a and Ctrl+q
2. Reload Zellij config: `Ctrl+a r`
3. Check for conflicting keybindings in your shell config

### Session Switching Issues
If session switching doesn't work smoothly, you may need to adjust the `sleep` delays in the `zellij-switch-session` script.

## Differences from Tmux

### Sessions vs Tabs
Zellij has a different mental model:
- **Tmux**: sessions → windows → panes
- **Zellij**: sessions → tabs → panes

Your tmux "sessions" map to Zellij "sessions", and tmux "windows" map to Zellij "tabs".

### No Client/Server Split
Zellij doesn't have the same client/server architecture as tmux. Each session is more self-contained.

### Plugin System
Zellij uses WASM plugins written in Rust. The bookmark bar plugin source is included if you want to customize it further.

## Building the Bookmark Bar Plugin (Optional)

If you want to use the compiled WASM plugin instead of the shell script:

```bash
cd ~/.config/zellij/plugins/bookmark-bar
cargo build --release --target wasm32-wasi
cp target/wasm32-wasi/release/bookmark_bar.wasm ~/.config/zellij/plugins/
```

Then update `layouts/default.kdl` to use the plugin instead of the shell command.

## Migration Checklist

- [ ] Install Zellij
- [ ] Symlink config files
- [ ] Test sessionizer (Ctrl+a o)
- [ ] Test bookmark functionality (Ctrl+a b, Alt+1-5)
- [ ] Test quick tab creation (Ctrl+a Ctrl+w)
- [ ] Test virtual overview (Ctrl+a v)
- [ ] Configure Ghostty to auto-start Zellij (optional)
- [ ] Update shell RC files if needed

## Going Back to Tmux

If you need to switch back to tmux temporarily, all your tmux config is still intact. Just run `tmux` instead of `zellij`.

The cache files are compatible between both, so your sessionizer will work the same way.

## Questions?

This migration preserves 100% of your tmux workflow while adding new features. If something doesn't work as expected, check:
1. Script permissions (chmod +x)
2. PATH includes ~/dotfiles/scripts/bin
3. Config files are symlinked correctly
4. Zellij version is 0.38.0 or later

Enjoy your new Zellij setup! 🚀
