{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.games;
in
{
  options.${namespace}.suites.games = with types; {
    enable = mkBoolOpt false "Whether or not to enable games configuration.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps = {
        steam = enabled;
        #nexusmods-app = enabled;
        discord = enabled;
        davinci-resolve = enabled;
      };
      services = {
        maestral = enabled;
      };
    };
  };
}
