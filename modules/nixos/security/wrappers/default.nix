{ options, config, lib, pkgs, ... }:
with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.security.wrappers;
in
{
  options.nixos-snowfall.security.wrappers = with types; {
    enable = mkBoolOpt false "Whether or not to enable wrappers";
  };

  config = mkIf cfg.enable {
    cfg.ubridge = {
      source = "/run/current-system/sw/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "ubridge";
      permissions = "u + rx,g+x";
    };
  };
}
