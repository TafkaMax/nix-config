{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.transmission;
in
{
  options.${namespace}.apps.transmission = with types; {
    enable = mkBoolOpt false "Whether or not to enable Transmission bittorrent client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      transmission_4
      transmission_4-gtk
    ];
  };
}
