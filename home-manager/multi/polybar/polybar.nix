{ nixosConfig, config, pkgs, lib, ... }:
{
  home.file."config.ini".target = ".config/polybar/config.ini";
  home.file."config.ini".source = if nixosConfig.setup.screen == "big" then ./polybar-big.nix else ./polybar-small.nix;
}
