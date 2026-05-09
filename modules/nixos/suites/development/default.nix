{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.development;
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
  options.${namespace}.suites.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {

    ${namespace} = {
      inherit apps cli-apps;

      tools = {
        direnv = enabled;
        http = enabled;
        docker = enabled;
        python = enabled;
        tio = enabled;
      };

      home.extraOptions = {
        home.packages = with pkgs; [
          inputs.nil.packages."${pkgs.stdenv.hostPlatform.system}".default # nix language server
        ];
      };
    };
  };
}
