{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.archetypes.workstation-slim;
in
{
  options.${namespace}.archetypes.workstation-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable the workstation-slim archetype.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        art = enabled;
        video = enabled;
        work-slim = enabled;
      };
    };
  };
}
