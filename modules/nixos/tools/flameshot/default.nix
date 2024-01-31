{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.tools.flameshot;

  flameshotfix = ''
    #!/run/current-system/sw/bin/bash
    env QT_QPA_PLATFORM=wayland flameshot gui
    EOF
  '';
in
{
  options.nixos-snowfall.tools.flameshot = with types; {
    enable = mkBoolOpt false "Whether or not to enable common flameshot utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ flameshot ];
    nixos-snowfall = {
      home.file = {
        ".local/bin/fixflameshot" = {
          text = flameshotfix;
          executable = true;
        };
      };
    };
  };
}
