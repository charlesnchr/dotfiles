# Tmux to Zellij Migration Guide

This directory contains a zellij configuration ported from your tmux setup.

## Directory Structure

```
zellij/
├── .config/zellij/
│   ├── config.kdl           # Main configuration
│   ├── layouts/
│   │   ├── default.kdl      # Standard 5-tab layout
│   │   ├── minimal.kdl      # Single tab
│   │   ├── work.kdl         # Development setup
│   │   └── dev.kdl          # Editor + terminal split
│   └── themes/
│       └── gruvbox-dark.kdl # Gruvbox theme
└── README-zellij-migration.md

ghostty-tmux/                 # Stow package for tmux ghostty config
└── Library/Application Support/com.mitchellh.ghostty/config

ghostty-zellij/               # Stow package for zellij ghostty config
└── Library/Application Support/com.mitchellh.ghostty/config
```

## Installation (using stow)

```bash
cd ~/dotfiles

# Install zellij config
stow zellij

# Install zellij helper scripts (if not already stowed)
stow scripts

# Switch ghostty to zellij mode
# First, unstow the old ghostty config if it was in home_folder_macos
stow -D home_folder_macos  # if ghostty was there

# Then stow the zellij ghostty config
stow ghostty-zellij
```

### Switching between tmux and zellij ghostty configs

```bash
cd ~/dotfiles

# Switch to tmux
stow -D ghostty-zellij && stow ghostty-tmux

# Switch to zellij
stow -D ghostty-tmux && stow ghostty-zellij
```

## Key Binding Comparison

| Action | Tmux | Zellij |
|--------|------|--------|
| Prefix | `Ctrl+a` | `Ctrl+a` (enters tmux mode) |
| Split horizontal | `prefix + "` | `prefix + "` or `prefix + s` |
| Split vertical | `prefix + %` | `prefix + %` or `prefix + v` |
| Navigate panes | `prefix + C-hjkl` | `prefix + hjkl` or `Alt + hjkl` |
| Resize panes | `prefix + HJKL` | `prefix + HJKL` |
| New tab/window | `prefix + c` | `prefix + c` |
| Next tab | `prefix + n` | `prefix + n` |
| Previous tab | `prefix + p` | `prefix + p` |
| Go to tab N | `prefix + N` | `prefix + N` |
| Close pane | `prefix + x` | `prefix + x` |
| Close tab | N/A | `prefix + X` |
| Zoom pane | `prefix + z` | `prefix + z` |
| Last pane | `prefix + /` | `prefix + /` |
| Last tab | `prefix + C-o` | `prefix + C-o` |
| Scroll/copy mode | `prefix + [` | `prefix + [` |
| Detach | `prefix + d` | `prefix + d` |
| Sessionizer | `prefix + o` | `prefix + o` |
| Rename tab | `prefix + ,` | `prefix + ,` |
| Bookmark session | `prefix + b` | `prefix + b` |

## Scripts

All helper scripts have zellij equivalents:

| Tmux Script | Zellij Script |
|-------------|---------------|
| `tmux-sessionizer` | `zellij-sessionizer` |
| `tmux-sessionizer-list` | `zellij-sessionizer-list` |
| `tmux-bookmark-add` | `zellij-bookmark-add` |
| `tmux-bookmark-session` | `zellij-bookmark-session` |
| `tmux-bookmark-clear-all` | `zellij-bookmark-clear-all` |
| `tmux-switch-to-recent` | `zellij-switch-to-bookmark` |
| `tmux-show-bookmarks` | `zellij-show-bookmarks` |
| `tmux-create-windows.sh` | `zellij-create-tabs` |
| `tmux-sort-windows.sh` | `zellij-sort-tabs` |
| `tmux-capture-output` | `zellij-capture-output` |

## Known Differences / Limitations

### Session Switching
**Tmux**: Can switch sessions from within tmux with `switch-client`
**Zellij**: Cannot switch sessions from within. Must either:
- Use the built-in session-manager plugin (`prefix + Ctrl+b`)
- Detach and reattach to a different session

### Tab Reordering
**Tmux**: `move-window` command allows programmatic reordering
**Zellij**: No CLI for reordering tabs yet. Manual reorder via Tab mode (`h`/`l` keys)

### Status Bar Customization
**Tmux**: Highly customizable with shell commands, colors, etc.
**Zellij**: Uses plugins for status bar. Less flexible but more consistent.

### Bookmark Bar Display
**Tmux**: Custom second status line showing bookmarks
**Zellij**: Not directly supported. Use `zellij-show-bookmarks` to view.

### Mouse Clicks on Status
**Tmux**: Clickable session name and bookmark bar
**Zellij**: Built-in tab bar is clickable, but no custom click handlers

### Plugins
**Tmux**: Shell-based plugins (tmux-jump, tmux-open, etc.)
**Zellij**: Wasm-based plugins. Different ecosystem.
- Jump: Use built-in search (`prefix + u` or `/` in scroll mode)
- Open URLs: Some Wasm plugins available, or use terminal's URL detection

## Layouts

Start zellij with a specific layout:
```bash
zellij --layout work
zellij --layout dev
zellij --layout minimal
```

Or set default in config.kdl:
```kdl
default_layout "work"
```

## Quick Start

```bash
# Start new session
zellij

# Start with name
zellij -s myproject

# Start with layout
zellij --layout work -s myproject

# Attach to existing
zellij attach myproject

# List sessions
zellij list-sessions

# Delete session
zellij delete-session myproject
```

## Ghostty Integration

The `ghostty-zellij-config` file provides the same keyboard shortcuts you're used to:
- `Cmd+1-9`: Switch to tab N
- `Cmd+[/]`: Previous/next tab
- `Cmd+o`: Open sessionizer
- `Opt+1-5`: Quick switch to bookmarked session

## Tips for Transition

1. **Modal vs Prefix**: Zellij is naturally modal (different modes for different tasks).
   The config here uses "tmux mode" to feel familiar, but you can also use:
   - `Alt+h/j/k/l` for pane navigation without prefix
   - `Alt+1-9` for tab switching without prefix

2. **Session Management**: Use the session-manager plugin (`prefix + Ctrl+b`) for
   a visual session picker.

3. **Scrollback**: `prefix + [` enters scroll mode with vim keys. `Ctrl+c` or `q` exits.

4. **Search**: In scroll mode, press `/` to search. `n`/`N` for next/previous match.

5. **Floating panes**: Zellij supports floating panes which tmux doesn't have natively.
   Try `prefix` then entering pane mode for this feature.
