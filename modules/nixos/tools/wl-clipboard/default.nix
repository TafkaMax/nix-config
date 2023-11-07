{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.wl-clipboard;
in
{
  options.nixos-snowfall.tools.wl-clipboard = with types; {
    enable = mkBoolOpt false "Whether or not to enable common wl-clipboard utilities.";
  };

  config =
    mkIf cfg.enable {
      nixos-snowfall.home.extraOptions = {

        home.packages = with pkgs; [
          wl-clipboard
        ];
      };
    };
}
