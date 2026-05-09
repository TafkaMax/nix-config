{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.sshfs;
  user = config.users.users.${config.${namespace}.user.name};
  user-id = builtins.toString user.uid;
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  # Creates all necessary directories.
  prepScript = pkgs.writeScript "sshfs-prep" (
    "#! ${pkgs.stdenv.shell} -eu \n"
    + concatMapStringsSep "\n" (u: "${mkdir} -p ${(getUser u).home}/${cfg.mountDir}") cfg.users
  );
in
{
  options.${namespace}.tools.sshfs = with types; {
    enable = mkBoolOpt false "Whether or not to enable sshfs-fuse utility.";
    fstabSupport = mkBoolOpt true "Whether or not to add mountPoints to fstab.";
    mountPoints = mkOpt (listOf str) [ ] "Mountpoints to add to /etc/fstab";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ sshfs-fuse ]; };

  #mountPointsToAdd = mkIf cfg.fstabSupport {
  #  fileSystems."/path" = { }

  #    };
}
