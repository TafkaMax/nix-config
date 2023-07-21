{ options, config, pkgs, lib, ... }:

# NOTE - this 'storage' is regarding mountable storage e.g. NFS etc.
with lib;
with lib.internal;
let cfg = config.nixos-snowfall.hardware.storage;
in
{
  options.nixos-snowfall.hardware.storage = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for extra storage devices.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ntfs3g fuseiso ];
  };
}
