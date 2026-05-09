{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {

    ${namespace} = {
      nix = enabled;

      #cache.public = enabled;

      apps = {
        kitty = enabled;
      };

      cli-apps = {
        flake = enabled;
        neovim = enabled;
      };

      tools = {
        agenix = enabled;
        git = enabled;
        misc = enabled;
        gnumake = enabled;
      };

      hardware = {
        audio = enabled;
        networking = enabled;
        diagnostics = enabled;
      };

      services = {
        printing = enabled;
        openssh = enabled;
      };

      security = {
        gpg = enabled;
      };

      system = {
        disk-encryption = enabled;
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
        fwupd = enabled;
      };
    };
  };
}
