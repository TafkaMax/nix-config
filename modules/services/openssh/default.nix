{ options, config, pkgs, lib, systems, name, format, inputs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.services.openssh;

  user = config.users.users.${config.nixos-snowfall.user.name};
  user-id = builtins.toString user.uid;

  # Disable default-key
  #default-key = disabled

  # TODO look into enabling these variables again.
  #other-hosts = lib.filterAttrs
  #  (key: host:
  #    key != name && (host.config.nixos-snowfall.user.name or null) != null)
  #  ((inputs.self.nixosConfigurations or { }) // (inputs.self.darwinConfigurations or { }));

  #other-hosts-config = lib.concatMapStringsSep
  #  "\n"
  #  (name:
  #    let
  #      remote = other-hosts.${name};
  #      remote-user-name = remote.config.nixos-snowfall.user.name;
  #      remote-user-id = builtins.toString remote.config.users.users.${remote-user-name}.uid;

  #      forward-gpg = optionalString (config.programs.gnupg.agent.enable && remote.config.programs.gnupg.agent.enable)
  #        ''
  #          RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent /run/user/${user-id}/gnupg/S.gpg-agent.extra
  #          RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent.ssh /run/user/${user-id}/gnupg/S.gpg-agent.ssh
  #        '';

  #    in
  #    ''
  #      Host ${name}
  #        User ${remote-user-name}
  #        ForwardAgent yes
  #        Port ${builtins.toString cfg.port}
  #        ${forward-gpg}
  #    ''
  #  )
  #  (builtins.attrNames other-hosts);
in
{
  options.nixos-snowfall.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure OpenSSH support.";
    authorizedKeys =
      mkOpt (listOf str) [ ] "The public keys to apply.";
    manage-other-hosts = mkOpt bool true "Whether or not to add other host configurations to SSH config.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = if format == "install-iso" then "yes" else "no";
        PasswordAuthentication = false;
      };

      extraConfig = ''
        StreamLocalBindUnlink yes
      '';

      ports = [
        22
      ];
    };

    #programs.ssh.extraConfig = ''
    #  Host *
    #    HostKeyAlgorithms +ssh-rsa

    #  ${optionalString cfg.manage-other-hosts other-hosts-config}
    #'';

    #nixos-snowfall.user.extraOptions.openssh.authorizedKeys.keys =
    #  cfg.authorizedKeys;

    #nixos-snowfall.home.extraOptions = {
    #  programs.zsh.shellAliases = foldl
    #    (aliases: system:
    #      aliases // {
    #        "ssh-${system}" = "ssh ${system} -t tmux a";
    #      })
    #    { }
    #    (builtins.attrNames other-hosts);
    #};
  };
}
