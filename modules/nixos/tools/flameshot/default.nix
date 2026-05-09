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

  flameshotfix = ''
    #!/run/current-system/sw/bin/bash
    env QT_QPA_PLATFORM=wayland flameshot gui
    EOF
  '';
in
{
  options.${namespace}.tools.flameshot = with types; {
    enable = mkBoolOpt false "Whether or not to enable common flameshot utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ flameshot ];
    ${namespace} = {
      home.file = {
        ".local/bin/fixflameshot" = {
          text = flameshotfix;
          executable = true;
        };
      };
    };
  };
}
