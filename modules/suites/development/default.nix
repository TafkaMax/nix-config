{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.suites.development;
  apps = {
    dbeaver = enabled;
    #    vscode = enabled;
    #    yubikey = enabled;
  };
  cli-apps = {
    #tmux = enabled;
    neovim = enabled;
    #yubikey = enabled;
    #prisma = enabled;
  };
in
{
  options.nixos-snowfall.suites.development = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    #networking.firewall.allowedTCPPorts = [
    #  12345
    #  3000
    #  3001
    #  8080
    #  8081
    #];

    nixos-snowfall = {
      inherit apps cli-apps;

      tools = {
        #attic = enabled;
        direnv = enabled;
        http = enabled;
        docker = enabled;
        #k8s = enabled;
        #node = enabled;
      };

      #virtualisation = { podman = enabled; };
    };

    nixos-snowfall.home.extraOptions = {
      home.packages = with pkgs; [
        inputs.nil.packages."${pkgs.system}".default # nix language server
      ];
    };
  };
}
