{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.development;
  apps = {
    dbeaver = enabled;
    obsidian = enabled;
  };
  cli-apps = {
    neovim = enabled;
    tmux = enabled;
    docker = enabled;
  };
in
{
  options.nixos-snowfall.suites.development = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {

    nixos-snowfall = {
      inherit apps cli-apps;

      tools = {
        direnv = enabled;
        http = enabled;
        docker = enabled;
      };

    };

    nixos-snowfall.home.extraOptions = {
      home.packages = with pkgs; [
        inputs.nil.packages."${pkgs.system}".default # nix language server
      ];
    };
  };
}
