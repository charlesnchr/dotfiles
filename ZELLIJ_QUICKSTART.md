# Zellij Quick Start

## Installation

```bash
# Run the setup script
~/dotfiles/scripts/setup-zellij.sh
```

## Launch

```bash
# Start new session
zellij

# Attach to existing
zellij attach

# Create named session
zellij -s myproject
```

## Essential Keybindings

All keybindings use the same prefix as tmux: `Ctrl+a` or `Ctrl+q`

### Session Management
- `Ctrl+a o` - Open sessionizer (fzf fuzzy finder)
- `Alt+1` to `Alt+5` - Switch to bookmarked session 1-5
- `Ctrl+a b` - Bookmark current session
- `Ctrl+a B` - Enter bookmark mode (then press 1-5 to set slot)
- `Ctrl+a v` - Open virtual session overview

### Tab Management
- `Ctrl+a c` - New tab
- `Ctrl+a ,` - Rename tab
- `Ctrl+a x` - Close tab
- `Ctrl+a Ctrl+w` - Create 5 standard tabs (zsh, ranger, nvim, claude, log)
- `Ctrl+a Ctrl+r` - Go to/create ranger tab
- `Ctrl+a Ctrl+e` - Go to/create nvim tab
- `Ctrl+a Ctrl+t` - Go to/create zsh tab

### Pane Navigation
- `Alt+h/j/k/l` - Move between panes (without prefix!)
- `Ctrl+a Ctrl+h/j/k/l` - Move between panes (with prefix)
- `Ctrl+a /` - Toggle pane fullscreen
- `Ctrl+a |` - Split horizontally
- `Ctrl+a \` - Split vertically

### Pane Resizing
- `Ctrl+a H/J/K/L` - Resize pane (hold and repeat)

## Scripts Reference

All scripts are in `~/dotfiles/scripts/bin/`:

| Script | Description |
|--------|-------------|
| `zellij-sessionizer` | Interactive session selector with fzf |
| `zellij-switch-session` | Switch to a named session |
| `zellij-switch-to-recent` | Switch to bookmarked session by index (1-5) |
| `zellij-bookmark-add` | Add current session to next available bookmark slot |
| `zellij-bookmark-session` | Toggle bookmark at specific slot |
| `zellij-bookmark-clear-all` | Clear all bookmarks |
| `zellij-show-bookmarks` | Display bookmark bar text |
| `zellij-create-tabs` | Create 5 standard tabs |
| `zellij-goto-or-create-tab` | Go to or create named tab |
| `zellij-goto-last-tab` | Go to last tab |
| `zellij-launch-overview` | Launch virtual session overview |
| `zellij-session-overview` | Display session in overview pane |
| `zellij-bookmark-bar-loop` | Continuous bookmark bar display |

## Layouts

Available in `~/.config/zellij/layouts/`:

- `default.kdl` - Standard layout with bookmark bar
- `simple.kdl` - Minimal layout without bookmark bar
- `overview.kdl` - Virtual session overview grid

Use a layout:
```bash
zellij -l simple
```

## Common Tasks

### Create a New Project Session
1. `Ctrl+a o` - Open sessionizer
2. Type to filter, select with arrows, Enter to open

### Bookmark Your Top 5 Projects
1. Switch to a project: `Ctrl+a o`
2. Bookmark it: `Ctrl+a b`
3. Or assign to specific slot: `Ctrl+a B 1` (for slot 1)

### Quick Switch Between Projects
Use `Alt+1` through `Alt+5` to instantly jump to bookmarked sessions

### Set Up a New Session
1. Create session: `Ctrl+a o` (select a directory)
2. Create standard tabs: `Ctrl+a Ctrl+w`
3. Bookmark it: `Ctrl+a b`

### View All Sessions at Once
Press `Ctrl+a v` to open the overview session showing all bookmarked sessions in a grid

## Tips

- The bookmark bar shows at the bottom of your terminal
- Click on tabs to switch between them
- Session cache is shared with tmux (if you were using tmux-sessionizer)
- All configs are in `~/.config/zellij/`
- Logs are in `~/.cache/zellij/`

## Troubleshooting

**Scripts not working?**
Ensure `~/dotfiles/scripts/bin` is in your PATH:
```bash
export PATH="$HOME/dotfiles/scripts/bin:$PATH"
```

**Bookmark bar not showing?**
Make sure you're using the default layout:
```bash
zellij -l default
```

**Keys not working in Ghostty?**
Check that Ghostty config is symlinked:
```bash
ls -l ~/.config/ghostty/config
```

## Learn More

- Full migration guide: `~/dotfiles/ZELLIJ_MIGRATION.md`
- Official docs: https://zellij.dev
- Config reference: `~/.config/zellij/config.kdl`
