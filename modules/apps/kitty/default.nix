{ options, config, lib, pkgs, ... }:

###########################################################
#
# Kitty Configuration
#
# Useful Hot Keys for Linux:
#   1. New Tab: `ctrl + shift + t`
#   2. Close Tab: `ctrl + shift + q`
#   3. Switch Tab: `ctrl + shift + right` | `ctrl + shift + left`
#   4. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
#   5. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
#   6. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
###########################################################

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
      environment.systemPackages = with pkgs; [ kitty ];

      # remove gnome console if kitty installed.
      environment.gnome.excludePackages = with pkgs; [
        gnome-console
      ];

      nixos-snowfall.home = {
        extraOptions = {
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
      };
    };
}
