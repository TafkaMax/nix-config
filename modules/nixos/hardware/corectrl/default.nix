{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.hardware.corectrl;
in
{
  options.nixos-snowfall.hardware.corectrl = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for corectrl.";
  };

  config = mkIf cfg.enable {
    programs.corectrl.enable = true;
  };
}
