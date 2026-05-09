{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.media;
in
{
  options.${namespace}.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media configuration.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps = {
        spotify = enabled;
        transmission = enabled;
      };
    };
  };
}
