{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.locale;
in
{
  options.${namespace}.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "et_EE.UTF-8/UTF-8"
      ];
      extraLocaleSettings = {
        LC_TIME = "et_EE.UTF-8";
      };
    };

    console = {
      keyMap = mkForce "us";
    };
  };
}
