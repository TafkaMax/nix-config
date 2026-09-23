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
  cfg = config.${namespace}.tools.claude-code;
in
{
  options.${namespace}.tools.claude-code = with types; {
    enable = mkBoolOpt false "Whether or not to enable claude-code.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      claude-code
      claude-agent-acp
    ];
  };
}
