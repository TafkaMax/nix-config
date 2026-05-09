{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.corectrl;
  user = config.${namespace}.user;
in
{
  options.${namespace}.hardware.corectrl = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for corectrl.";
  };

  config = mkIf cfg.enable {
    programs.corectrl.enable = true;

    users.users.${user.name}.extraGroups = [ "corectrl" ];
  };
}
