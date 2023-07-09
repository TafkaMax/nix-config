{ config, pkgs, lib, ... }:
{
  imports = [
    ./plymouth.nix
    ./packages.nix
    ./gui-packages.nix
    ./script-packages.nix
    ./programs.nix
    ./users.nix
    ./audio.nix
    ./agent.nix
    ./virtualisation.nix   
    ./environment.nix
    ./shell.nix
    ./options.nix
    ./theme.nix
    ./console.nix
  ];
}
