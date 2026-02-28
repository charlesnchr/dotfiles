import json

path = '/Users/cnc40853/dotfiles/dotfiles_private/home_folder/.config/opencode/opencode.json'

with open(path, 'r') as f:
    data = json.load(f)

plugins = data.get('plugin', [])
if "./plugin/claude-hooks-compat.ts" in plugins:
    plugins.remove("./plugin/claude-hooks-compat.ts")
data['plugin'] = plugins

with open(path, 'w') as f:
    json.dump(data, f, indent=2)

