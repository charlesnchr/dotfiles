import json

with open('/Users/cnc40853/dotfiles/home_folder_macos/.config/karabiner/karabiner-template/rules.json', 'r') as f:
    data = json.load(f)

print([r['description'] for r in data['rules']])
