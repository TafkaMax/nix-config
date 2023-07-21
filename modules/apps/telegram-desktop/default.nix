{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.apps.telegram-desktop;
in
{
  options.nixos-snowfall.apps.telegram-desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable Telegram Desktop.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ telegram-desktop ];
  };
}
