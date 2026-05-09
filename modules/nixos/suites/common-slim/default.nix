{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.common-slim;
in
{
  options.${namespace}.suites.common-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable common-slim configuration.";
  };

  config = mkIf cfg.enable {

    ${namespace} = {
      nix = enabled;

      #cache.public = enabled;

      cli-apps = {
        flake = enabled;
      };

      tools = {
        git = enabled;
        agenix = enabled;
        #fup-repl = enabled;
        #comma = enabled;
        #bottom = enabled;
        direnv = enabled;
      };

      hardware = {
        #storage = enabled;
        networking = enabled;
      };

      services = {
        openssh = enabled;
        #tailscale = enabled;
      };

      security = { };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
