{ config, lib, ... }:
{
    nixpkgs.overlays = [ (import ../pkgs) ];
}
