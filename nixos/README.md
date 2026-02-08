# NixOS Bootstrap (cc)

Minimal, repeatable setup for a fresh NixOS install using this repo.

## One-liner (fresh machine)

```sh
nix-shell -p git --run 'git clone https://github.com/charlesnchr/dotfiles.git ~/dotfiles'
bash ~/dotfiles/nixos/install_nixos.sh
```

## What It Does

- Installs system packages + services via a NixOS module (`/etc/nixos/cc-dotfiles.nix`)
- Disables suspend/hibernate/idle sleep
- Stows dotfiles (`home_folder`, `nvim`, `scripts`)
- Sets up: zimfw, TPM (tmux plugins), fzf bindings, fnm+Node 22, corepack+yarn, pyenv Python 3.12 + `pynvim`, Neovim plugins, Claude

