{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      desktop = {
        gnome = enabled;
        addons = {
          wallpapers = enabled;
        };
      };

      apps = {
        firefox = enabled;
        vlc = enabled;
        remmina = enabled;
        libreoffice = enabled;
        qdigidoc = enabled;
      };

      tools = {
        flameshot = enabled;
        wl-clipboard = enabled;
        logiops = enabled;
      };

      security = {
        keepassxc = enabled;
        keyring = enabled;
      };
    };
  };
}
