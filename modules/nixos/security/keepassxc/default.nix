{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.security.keepassxc;
in
{
  options.nixos-snowfall.security.keepassxc = with types; {
    enable = mkBoolOpt false "Whether to enable keepassxc.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
