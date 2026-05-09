{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.art;
in
{
  options.${namespace}.suites.art = with types; {
    enable = mkBoolOpt false "Whether or not to enable art configuration.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps = {
        gimp = enabled;
      };
    };
  };
}
