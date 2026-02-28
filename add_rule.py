import json

path = '/Users/cnc40853/dotfiles/home_folder_macos/.config/karabiner/karabiner-template/rules.json'
with open(path, 'r') as f:
    data = json.load(f)

new_rule = {
  "description": "Map fn to option F17",
  "manipulators": [
    {
      "from": {
        "key_code": "fn",
        "modifiers": {
          "optional": ["any"]
        }
      },
      "to": [
        {
          "key_code": "f17",
          "modifiers": ["left_option"]
        }
      ],
      "type": "basic"
    }
  ]
}

# check if already exists
existing = [i for i, r in enumerate(data['rules']) if r['description'] == "Map fn to option F17"]
if existing:
    data['rules'][existing[0]] = new_rule
else:
    data['rules'].append(new_rule)

with open(path, 'w') as f:
    json.dump(data, f, indent=2)

