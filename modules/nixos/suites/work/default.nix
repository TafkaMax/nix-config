{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.work;
in
{
  options.${namespace}.suites.work = with types; {
    enable = mkBoolOpt false "Whether or not to enable work PC configuration.";
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
        gns3 = enabled;
        virtualbox = enabled;
        libvirtd = enabled;
        wireshark = enabled;
        apache-directory-studio = enabled;
        misc-work = enabled;
        #sshfs = enabled;
      };
    };
  };
}
