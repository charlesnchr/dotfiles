import re

path = '/Users/cnc40853/dotfiles/dotfiles_private/home_folder/.config/opencode/plugin/claude-hooks-compat.ts'
with open(path, 'r') as f:
    text = f.read()

text = text.replace(
    'const runQuietly = async (cmd: string) => {',
    'const runQuietly = (cmd: string) => {'
)
text = text.replace(
    'await $`bash -c ${cmd}`.quiet();',
    '$`bash -c ${cmd}`.quiet().catch(() => {});'
)
text = text.replace('await runQuietly(', 'runQuietly(')

with open(path, 'w') as f:
    f.write(text)

