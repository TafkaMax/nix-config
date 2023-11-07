{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.thunderbird;
  user = config.nixos-snowfall.user.name;
in
{
  options.nixos-snowfall.apps.thunderbird = with types; {
    enable = mkBoolOpt false "Whether or not to enable Thundebird mail client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ thunderbird ];

    # manage thunderbird using home-manager
    nixos-snowfall.home = {
      extraOptions = {
        accounts.email.account.${user.name} = {
          primary = true;
          address = user.email;
          thunderbird.enable = true;
          realname = user.fullName;
        };
      };
      programs.thunderbird = {
        enable = true;
        profiles = {
          ${user.name} = {
            isDefault = true;
          };
        };
      };
    };
  };
}
