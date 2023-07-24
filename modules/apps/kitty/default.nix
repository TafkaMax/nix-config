{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.apps.kitty;
in
{
  options.nixos-snowfall.apps.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to enable Kitty.";
  };

  config =
    mkIf cfg.enable {
      programs.kitty = {
        enable = true;
        theme = "Relaxed Afterglow";
        font = {
          name = "JetBrainsMono Nerd Font";
        };

        settings = {
          background_opacity = "0.95";
          scrollback_lines = 10000;
          enable_audio_bell = false;
        };
      };
    };
}
