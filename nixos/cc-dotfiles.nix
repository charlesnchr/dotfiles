{ config, pkgs, lib, ... }:

{
  # Helps run downloaded, non-Nix binaries (fnm-managed Node, Claude installer, etc).
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  # Keep the machine from sleeping/turning off due to lid/power/idle.
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "ignore";
    HandleSuspendKey = "ignore";
    HandleSuspendKeyLongPress = "ignore";
    HandleHibernateKey = "ignore";
    HandleHibernateKeyLongPress = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
    IdleActionSec = "0";
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # If you use an X11 session, also disable screen blanking/DPMS.
  services.xserver.displayManager.sessionCommands = lib.mkIf config.services.xserver.enable ''
    xset s off || true
    xset s noblank || true
    xset -dpms || true
  '';

  # Containers (parity with helsinki)
  virtualisation.docker.enable = true;
  users.users.cc.extraGroups = lib.mkAfter [ "docker" ];

  environment.systemPackages = with pkgs; [
    # System essentials
    zsh
    tmux
    git
    curl
    wget
    rsync

    # Build deps (pyenv builds)
    gcc
    gnumake
    pkg-config
    patchelf

    openssl
    openssl.dev
    zlib
    zlib.dev
    bzip2
    bzip2.dev
    readline
    readline.dev
    sqlite
    sqlite.dev
    ncurses
    ncurses.dev
    xz
    xz.dev
    tk
    tk.dev
    libffi
    libffi.dev

    jq
    stow
    ranger
    zip
    unzip

    # Core tools
    neovim
    pyenv
    uv
    fnm
    fzf
    ripgrep
    fd
    bat
    zoxide
    direnv
    gh
    atuin
    autojump
    tmuxinator
    universal-ctags

    # Dev/ops utilities
    docker
    docker-compose
    btop
    htop
    ncdu
    lsof
    nettools   # netstat
    dnsutils   # dig
    bun
    rclone

    # Fallbacks (useful even if you keep fnm/pyenv)
    python312
    nodejs_22
  ];
}
