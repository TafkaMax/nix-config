{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.direnv;
in
{
  options.nixos-snowfall.tools.direnv = with types; {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.home.extraOptions = {
      programs.direnv = {
        enable = true;
        nix-direnv = enabled;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
