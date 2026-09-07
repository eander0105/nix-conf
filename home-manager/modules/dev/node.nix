{ config, ... }:

{
  # `npm i -g` normally tries to write into the nodejs package in the Nix
  # store, which is read-only. Point npm's global prefix at a directory in
  # $HOME instead, and put its bin dir on PATH, so global installs work the
  # same way they do on any other distro.
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];
}
