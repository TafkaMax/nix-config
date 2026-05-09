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
  cfg = config.${namespace}.security.keyring;
in
{
  options.${namespace}.security.keyring = with types; {
    enable = mkBoolOpt false "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-keyring
      libgnome-keyring
    ];

    services.gnome.gcr-ssh-agent.enable = false;

    ${namespace}.home = {
      extraOptions = {
        home.file = mkIf config.${namespace}.security.gpg.enable {
          ".config/environment.d/10-ssh-auth-sock.conf" = {
            text = ''
              SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
            '';
          };
        };
      };
    };
  };
}
