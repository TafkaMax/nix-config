{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.wireshark;
in
{
  options.${namespace}.tools.wireshark = with types; {
    enable = mkBoolOpt false "Whether or not to enable common wireshark utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wireshark
      tshark
    ];
  };
}
