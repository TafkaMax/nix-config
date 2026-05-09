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
  cfg = config.${namespace}.tools.wl-clipboard;
in
{
  options.${namespace}.tools.wl-clipboard = with types; {
    enable = mkBoolOpt false "Whether or not to enable common wl-clipboard utilities.";
  };

  config = mkIf cfg.enable {
    ${namespace}.home.extraOptions = {

      home.packages = with pkgs; [
        wl-clipboard
      ];
    };
  };
}
