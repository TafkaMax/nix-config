inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.tools.agenix;
in
{
  options.nixos-snowfall.tools.agenix = with types; {
    enable = mkBoolOpt false "Whether or not to enable agenix.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.home.extraOptions = {
      home.packages = with pkgs; [
        agenix
      ];
    };
  };
}
