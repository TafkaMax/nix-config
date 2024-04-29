{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.work;
in
{
  options.nixos-snowfall.suites.work = with types; {
    enable = mkBoolOpt false "Whether or not to enable work PC configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      apps = {
        element = enabled;
        thunderbird = enabled;
        zoom-us = enabled;
        drawio = enabled;
      };
      tools = {
        gns3 = enabled;
        virtualbox = enabled;
        libvirtd = enabled;
        wireshark = enabled;
        #sshfs = enabled;
      };
    };
  };
}
