{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.work-slim;
in
{
  options.${namespace}.suites.work-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable work-slim PC configuration.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps = {
        element = enabled;
        thunderbird = enabled;
        zoom-us = enabled;
        drawio = enabled;
        yed = enabled;
        gamja = enabled;
        spotify = enabled;
      };
      tools = {
        wireshark = enabled;
        apache-directory-studio = enabled;
        misc-work = enabled;
      };
    };
  };
}
