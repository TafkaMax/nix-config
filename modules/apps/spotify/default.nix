{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.spotify;
in
{
  options.nixos-snowfall.apps.spotify = with types; {
    enable = mkBoolOpt false "Whether or not to enable Spotify.";
  };

  config =
    mkIf cfg.enable {
      nixos-snowfall.home.extraOptions = {
        home.packages = with pkgs; [
          spotify
        ];
      };
    };
}
