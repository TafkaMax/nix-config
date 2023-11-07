{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.thunderbird;
  user = config.nixos-snowfall.user;
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
        programs.thunderbird = {
          enable = true;
          profiles = {
            "${user.name}-profile" = {
              isDefault = true;
              settings = user.emailOptions.settings;
            };
          };
        };
        accounts.email.accounts.${user.name} = {
          primary = true;
          address = user.email;
          thunderbird.enable = true;
          realName = user.fullName;
        };
      };
    };
  };
}
