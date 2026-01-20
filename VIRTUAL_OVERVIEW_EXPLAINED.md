# Virtual Session Overview - How It Works

## What It Is

The Virtual Overview is a special Zellij session that gives you a **dashboard view** of all your bookmarked sessions. Press `Ctrl+a v` to launch it.

## Layout

When you open the overview, you get a 6-pane grid:

```
┌──────────────┬──────────────┐
│  Bookmark 1  │  Bookmark 2  │
├──────────────┼──────────────┤
│  Bookmark 3  │  Bookmark 4  │
├──────────────┴──────────────┤
│  Bookmark 5  │               │
├──────────────┤    Claude     │
│              │     Pane      │
└──────────────┴───────────────┘
```

## What Each Pane Shows

### Bookmark Panes (1-5)
Each pane displays:
- 📍 **Session name** from that bookmark slot
- 🟢/🟡 **Status** (Active if you're currently in it, Running otherwise)
- 📂 **Session info**
- ⚡ **Quick actions** (Alt+1-5 to jump to that session)
- 🕒 **Last updated** timestamp (updates every 2 seconds)

**Example:**
```
═══════════════════════════════════════
  📍 Slot 1: my-dotfiles
═══════════════════════════════════════

🟡 Status: Running

📂 Session exists

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Alt+1  → Switch to this session
  Ctrl+a B 1 → Rebookmark this slot

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Last updated: 19:45:23
```

### Claude Pane
A dedicated pane for running `claude-code` or any other tool you want accessible from all sessions. This is **your** shared workspace.

## Important: Not True Mirroring

**Limitation**: Zellij doesn't support true session mirroring like tmux's `link-window`.

**What this means:**
- ❌ You don't see live terminal output from other sessions
- ✅ You see session status and quick-switch buttons
- ✅ One keypress (Alt+1-5) switches you to the full session

**Why this is still useful:**
1. **Visual overview** - See all your active sessions at a glance
2. **Quick navigation** - Jump to any session with Alt+1-5
3. **Status monitoring** - See which sessions are running
4. **Shared Claude pane** - Keep Claude open in a dedicated space

## Use Cases

### 1. Project Dashboard
Open the overview while working on multiple projects:
```bash
# From any session
Ctrl+a v  # Open overview

# Now you see:
# [1] backend-api    [2] frontend-app
# [3] docs-site      [4] dotfiles
# [5] experiments    [Claude running]
```

Press `Alt+2` → Jump to frontend-app
Press `Alt+1` → Jump to backend-api
Press `Ctrl+a v` → Back to overview

### 2. Claude Across All Sessions
The Claude pane is always in the same place:
- Open claude-code in the Claude pane
- Switch between sessions (Alt+1-5)
- Claude stays running in the overview
- Jump back to overview to interact with Claude

### 3. Session Monitoring
Leave the overview open on a second monitor to see:
- Which sessions are active
- Session status updates
- Quick jump to any session

## How to Use

### Setup Bookmarks
First, bookmark your sessions:
```bash
# In session 1 (your main project)
Ctrl+a b        # Bookmark to next available slot
# or
Ctrl+a B 1      # Bookmark to specific slot 1

# In session 2 (another project)
Ctrl+a B 2      # Bookmark to slot 2

# Repeat for sessions 3, 4, 5
```

### Launch Overview
```bash
Ctrl+a v        # Launch virtual overview
```

You'll see a grid with all 5 bookmarked sessions + Claude pane.

### Navigate
From the overview:
- `Alt+1` through `Alt+5` - Jump to that session
- Click the Claude pane - Start using it
- `Ctrl+a v` - When in another session, jump back to overview

### Close Overview
```bash
# From the overview session
Ctrl+a x        # Close the overview tab
# or
Ctrl+a d        # Detach (keeps it running in background)
```

## Comparison to tmux

**What tmux could do:**
- Show live terminal content from other sessions (with `link-window`)
- True session mirroring with synchronized view

**What Zellij does:**
- Shows session metadata and status
- Provides quick navigation hub
- One keypress to see full content (Alt+1-5)

## Future Improvements

Possible enhancements:
1. **Zellij Plugin** - Could show more session details via API
2. **Watch output** - Could use `zellij pipe` to stream specific pane content
3. **Session logs** - Could tail recent output from each session
4. **Interactive links** - Click to switch sessions

## Tips

1. **Use with second monitor**: Keep overview on one screen, work on another
2. **Bookmark your main projects**: The 5 slots are perfect for your top projects
3. **Claude pane**: Run `claude-code` here and never lose it when switching
4. **Quick peek**: `Ctrl+a v` → check all sessions → `Alt+N` → back to work
5. **Detach, don't close**: Use `Ctrl+a d` to keep overview running

## Technical Details

**Scripts involved:**
- `zellij-launch-overview` - Launches the overview session
- `zellij-session-overview` - Displays info for each bookmark slot
- Layout: `~/.config/zellij/layouts/overview.kdl`

**How it works:**
1. Creates a special session named "overview"
2. Uses the overview layout (6-pane grid)
3. Each pane runs `zellij-session-overview <slot>`
4. Script loops every 2 seconds updating status
5. Alt+1-5 keybindings work globally to jump to sessions

**Cache files:**
- `~/.cache/zellij-session-bookmarks` - Stores slot→session mappings

## Troubleshooting

**"No session bookmarked" in all panes**
- You need to bookmark sessions first
- Use `Ctrl+a b` or `Ctrl+a B <1-5>` in each session

**Overview won't launch**
- Make sure scripts are in your PATH
- Check: `which zellij-launch-overview`
- Make sure layout file exists: `ls ~/.config/zellij/layouts/overview.kdl`

**Status not updating**
- The script updates every 2 seconds automatically
- If frozen, close and relaunch: `Ctrl+a v`

**Can't see session content**
- This is expected (not true mirroring)
- Press Alt+1-5 to jump to the session to see full content

## The Bottom Line

The virtual overview is a **navigation hub and dashboard**, not a true mirror of other sessions. Think of it as:

- ✅ Mission control for your sessions
- ✅ Quick-switch interface
- ✅ Status dashboard
- ❌ Not a live view of terminal content

For full content, use Alt+1-5 to jump to the session (which is just as fast as looking at it in a mirror would be).
