{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.docker;
  user = config.${namespace}.user;
in
{
  options.${namespace}.cli-apps.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable docker.";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${user.name}.extraGroups = [ "docker" ];
  };
}
