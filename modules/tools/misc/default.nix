{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.nixos-snowfall.tools.misc;
in
{
  options.nixos-snowfall.tools.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      fzf
      killall
      unzip
      file
      jq
      clac
      wget
    ];
  };
}
