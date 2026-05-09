{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.telegram-desktop;
in
{
  options.${namespace}.apps.telegram-desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable Telegram Desktop.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ telegram-desktop ];
  };
}
