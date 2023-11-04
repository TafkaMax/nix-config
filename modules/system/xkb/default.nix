{ options, config, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.system.xkb;
in
{
  options.nixos-snowfall.system.xkb = with types; {
    enable = mkBoolOpt false "Whether or not to configure xkb.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "us";
      #xkbOptions = "caps:escape";
    };
  };
}
