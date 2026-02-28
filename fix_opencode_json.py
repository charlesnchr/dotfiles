import json

path = '/Users/cnc40853/dotfiles/dotfiles_private/home_folder/.config/opencode/opencode.json'

with open(path, 'r') as f:
    text = f.read()

# Try to parse using a simple method or fallback to regex since it has trailing commas.
# Let's fix the trailing comma manually in text
text = text.replace('"./plugin/vertex-auth-fix.ts",\n  ]', '"./plugin/vertex-auth-fix.ts"\n  ]')

data = json.loads(text)

if 'azure' in data.get('provider', {}):
    del data['provider']['azure']

with open(path, 'w') as f:
    json.dump(data, f, indent=2)

