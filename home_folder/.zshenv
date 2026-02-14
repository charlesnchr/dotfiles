
# Prevent Ubuntu's /etc/zsh/zshrc from calling compinit before zim
skip_global_compinit=1

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/bin:$PATH"
# Set ZDOTDIR if you want to re-home Zsh.
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export ZDOTDIR=${ZDOTDIR:-$HOME}

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Set the list of directories that zsh searches for commands.
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  # Prefer rustup shims (cargo/rustc/rust-analyzer) over Homebrew's `rust`.
  /opt/homebrew/opt/rustup/bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

colo() {
    if [ $(cat ~/dotfiles/is_dark_mode) -eq 1 ]; then x=0; else x=1; fi; echo $x > ~/dotfiles/is_dark_mode
}

# Homebrew
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Ensure rustup shims win even after `brew shellenv` prepends Homebrew's bin dirs.
path=( /opt/homebrew/opt/rustup/bin(N) $path )

# Optional: rustup adds this; avoid hard-failing on machines without it.
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
