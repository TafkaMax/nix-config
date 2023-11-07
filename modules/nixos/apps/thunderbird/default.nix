{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.thunderbird;
  user = config.nixos-snowfall.user;
in
{
  options.nixos-snowfall.apps.thunderbird = with types; {
    enable = mkBoolOpt false "Whether or not to enable Thundebird mail client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ thunderbird ];

    # manage thunderbird using home-manager
    nixos-snowfall.home = {
      extraOptions = {
        programs.thunderbird = {
          enable = true;
          profiles = {
            "${user.name}-profile" = {
              isDefault = true;
              settings = user.emailOptions.settings;
            };
          };
        };
        accounts.email.accounts.${user.name} = {
          primary = true;
          address = user.email;
          thunderbird = {
            enable = true;
            settings = id: {
              "mail.identity.id_${id}.reply_on_top" = 1;
              "mail.identity.id_${id}.sig_bottom" = false;
              "mailnews.default_sort_order" = 2;
              "mailnews.default_sort_type" = 18;
              "mailnews.default_view_flags" = 0;
              "mail.imap.expunge_after_delete" = true;
              "mail.server.default.delete_model" = 2;
              "mail.warn_on_delete_from_trash" = false;
              "mail.warn_on_shift_delete" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.rejected" = true;
              "toolkit.telemetry.prompted" = 2;
              "msgcompose.default_colors" = false;
              "msgcompose.text_color" = "#9a9996";
              "msgcompose.background_color" = "#000000";
            };
          };
          realName = user.fullName;
          imap = {
            host = user.emailOptions.host;
            port = 993;
            tls = {
              enable = true;
            };
          };
          signature = user.emailOptions.signature;
          smtp =
            {
              host = user.emailOptions.host;
              port = 25;
              tls = {
                enable = true;
                useStartTls = true;
              };
            };
          userName = user.name;
        };
      };
    };
  };
}
