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

  # Containers
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    zsh tmux git curl wget rsync jq stow ranger zip unzip
    neovim pyenv uv fnm fzf ripgrep fd bat zoxide direnv gh atuin autojump tmuxinator universal-ctags
    docker docker-compose btop htop ncdu lsof nettools dnsutils bun rclone
  ];
}
