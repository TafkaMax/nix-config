{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.vscode;
in
{
  options.nixos-snowfall.apps.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to enable vscode.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ vscode ]; };
}
