{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.security.keyring;
in
{
  options.nixos-snowfall.security.keyring = with types; {
    enable = mkBoolOpt false "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome.gnome-keyring
      gnome.libgnome-keyring
    ];


    nixos-snowfall.home = {
      extraOptions = {

        home.file = mkIf config.nixos-snowall.security.gpg.enable {
          ".config/autostart/gnome-keyring-ssh.desktop" = {
            text = ''
              Hidden=true
            '';
          };

          ".config/environment.d/10-ssh-auth-sock.conf" = {
            text = (builtins.readFile /home/${config.nixos-snowfall.user.name}/.config/environment.d/10-ssh-auth-sock.conf) + ''
              SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
            '';
          };
        };
      };
    };
  }
