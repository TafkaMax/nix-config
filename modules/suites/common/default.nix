{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.suites.common;
in
{
  options.nixos-snowfall.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nixos-snowfall.list-iommu
    ];

    nixos-snowfall = {
      nix = enabled;

      #cache.public = enabled;

      apps = {
        kitty = enabled;
      };

      cli-apps = {
        flake = enabled;
      };

      tools = {
        agenix = enabled;
        git = enabled;
        misc = enabled;
        gnumake = enabled;
      };

      hardware = {
        audio = enabled;
        networking = enabled;
      };

      services = {
        printing = enabled;
        openssh = enabled;
      };

      security = {
        # disable for now
        #gpg = enabled;
        doas = enabled;
      };

      system = {
        disk-encryption = enabled;
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
