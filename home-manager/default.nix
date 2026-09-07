{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./modules/gnome
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/nvim.nix
    ./modules/dev/java.nix
    ./modules/dev/node.nix
    ./modules/obsidian.nix

    # ./modules/game/battle.net.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
  # Without this, home.sessionVariables/sessionPath (NPM_CONFIG_PREFIX etc.)
  # only reach login shells, since ~/.bashrc doesn't exist to source
  # hm-session-vars.sh for regular interactive shells.
  programs.bash = {
    enable = true;
    # Preserve the line from the pre-existing ~/.profile (rustup/uv installer).
    profileExtra = ''
      . "$HOME/.local/bin/env"
    '';
  };

  home.stateVersion = "24.11";
}
