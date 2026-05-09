{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.archetypes.gaming;
in
{
  options.${namespace}.archetypes.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable the gaming archetype.";
  };

  config = mkIf cfg.enable {
    ${namespace}.suites = {
      common = enabled;
      desktop = enabled;
      social = enabled;
      media = enabled;
      video = enabled;
      games = enabled;
      art = enabled;
    };
  };
}
