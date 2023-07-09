{ config, pkgs, lib, ... }:
{
  imports = [
    ./services/wayvnc.nix
  ];
}
