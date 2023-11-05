{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.common-slim;
in
{
  options.nixos-snowfall.suites.common-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable common-slim configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nixos-snowfall.list-iommu
    ];

    nixos-snowfall = {
      nix = enabled;

      #cache.public = enabled;

      cli-apps = {
        flake = enabled;
      };

      tools = {
        git = enabled;
        agenix = enabled;
        #fup-repl = enabled;
        #comma = enabled;
        #bottom = enabled;
        direnv = enabled;
      };

      hardware = {
        #storage = enabled;
        networking = enabled;
      };

      services = {
        openssh = enabled;
        #tailscale = enabled;
      };

      security = {
        doas = enabled;
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
