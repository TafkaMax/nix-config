{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.networking;
in
{
  options.${namespace}.hardware.networking = with types; {
    enable = mkBoolOpt false "Whether or not to enable networking support";
    hosts = mkOpt attrs { } "An attribute set to merge with <option>networking.hosts</option>";
  };

  config = mkIf cfg.enable {
    ${namespace}.user.extraGroups = [ "networkmanager" ];

    networking = {
      hosts = {
        "127.0.0.1" = [ "local.test" ] ++ (cfg.hosts."127.0.0.1" or [ ]);
      }
      // cfg.hosts;

      networkmanager = {
        enable = true;
      };
    };

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    # Comment out for now.
    #systemd.services.NetworkManager-wait-online.enable = false;
  };
}
