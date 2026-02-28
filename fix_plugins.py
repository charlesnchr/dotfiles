import json
path = '/Users/cnc40853/dotfiles/dotfiles_private/home_folder/.config/opencode/opencode.json'
with open(path, 'r') as f: data = json.load(f)

# Revert strictly to just vertex-auth-fix
data['plugin'] = [
    "./plugin/vertex-auth-fix.ts"
]

with open(path, 'w') as f: json.dump(data, f, indent=2)
