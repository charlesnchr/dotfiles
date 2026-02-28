import re

path = '/Users/cnc40853/dotfiles/dotfiles_private/home_folder/.config/opencode/plugin/claude-hooks-compat.ts'
with open(path, 'r') as f:
    text = f.read()

# Make the execution truly detached to prevent any freezing
text = text.replace(
    '$`bash -c ${cmd}`.quiet().catch(() => {});',
    'Bun.spawn(["bash", "-c", cmd], { stdin: "ignore", stdout: "ignore", stderr: "ignore" }).unref();'
)

with open(path, 'w') as f:
    f.write(text)

