{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.virtualbox;
  user = config.${namespace}.user;
in
{
  options.${namespace}.tools.virtualbox = with types; {
    enable = mkBoolOpt false "Whether or not to enable virtualbox.";
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    users.extraGroups.vboxusers.members = [ "${user.name}" ];
  };
}
