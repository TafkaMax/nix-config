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
  cfg = config.${namespace}.tools.flameshot;

  flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" ''
    export QT_QPA_PLATFORM=wayland
    exec ${pkgs.flameshot}/bin/flameshot gui "$@"
  '';
in
{
  options.${namespace}.tools.flameshot = with types; {
    enable = mkBoolOpt false "Whether or not to enable common flameshot utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.flameshot
      flameshot-gui
    ];
  };
}
